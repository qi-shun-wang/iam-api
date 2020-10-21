import Vapor


final class GroupUserController: RouteCollection {
  
    func boot(routes: RoutesBuilder) throws {
        //        let allowedPolicy = Application.IAMAuthPolicyMiddleware(allowed: [IAMPolicyIdentifier.root])
        let groups = routes.grouped("groups")//.grouped(allowedPolicy)
        let users = routes.grouped("users")//.grouped(allowedPolicy)
        users.get(":user_id", "groups", use: indexGroups)
        groups.get(":group_id", "users", use: indexUsers)
        groups.delete(":group_id", "users", ":user_id", use: delete)
        groups.post(":group_id", "users", ":user_id", use: create)
    }
    
    func selectGroupAndUser(_ req: Request) throws -> EventLoopFuture<GroupUser> {
        guard let groupIDString = req.parameters.get("group_id"),
              let userIDString = req.parameters.get("user_id"),
              let groupID = Group.IDValue(groupIDString),
              let userID = User.IDValue(userIDString)
        else {throw Abort(.notFound)}
        let findGroupFuture = req.groupRepository.find(id: groupID)
            .flatMapThrowing { (result) -> Group in
                if let group = result {
                    return group
                } else {
                    throw Abort(.notFound)
                }
            }
        let findUserFuture = req.userRepository.find(id: userID)
            .flatMapThrowing { (result) -> User in
                if let user = result {
                    return user
                } else {
                    throw Abort(.notFound)
                }
            }
        
        let pivotFuture = findGroupFuture
            .and(findUserFuture)
            .flatMapThrowing { (group, user) -> GroupUser in
                return try GroupUser(group: group, user: user)
            }
        return pivotFuture
    }
    
    
    func create(_ req: Request) throws -> EventLoopFuture<Response> {
        let selectGroupAndUserFuture = try selectGroupAndUser(req)
        
        let findPivotFuture = selectGroupAndUserFuture.flatMap { (newPivot) -> EventLoopFuture<GroupUser> in
            let createPivotFuture = req.groupUserRepository
                .findPivot(newPivot.group, newPivot.user)
                .flatMap { (result) -> EventLoopFuture<GroupUser> in
                    if let pivot = result {
                        return req.eventLoop.future(pivot)
                    } else {
                        return req.groupUserRepository.create(newPivot)
                        
                    }
                }
            return createPivotFuture
        }
        
        let responseFuture = findPivotFuture.flatMapThrowing { (p) -> Response in
            return Response(status:.ok)
        }
        return responseFuture
    }
    
    func delete(_ req: Request) throws -> EventLoopFuture<Response> {
        let selectGroupAndUserFuture = try selectGroupAndUser(req)
        
        let findPivotFuture = selectGroupAndUserFuture.flatMap { (newPivot) -> EventLoopFuture<GroupUser> in
            return req.groupUserRepository
                .findPivot(newPivot.group, newPivot.user)
                .flatMapThrowing { (result) -> GroupUser in
                    if let pivot = result {
                        return pivot
                    } else {
                        throw Abort(.notFound)
                    }
                }
        }
        let responseFuture = findPivotFuture.flatMap { (pivot) -> EventLoopFuture<Response> in
            return req.groupUserRepository.delete(pivot).transform(to: Response(status:.ok))
        }
        
        return responseFuture
    }
    
    func indexUsers(_ req: Request) throws -> EventLoopFuture<[User]> {
        
        guard let groupIDString = req.parameters.get("group_id"),
              let groupID = Group.IDValue(groupIDString)
        else {throw Abort(.notFound)}
        let findGroupFuture = req.groupRepository.find(id: groupID)
            .flatMapThrowing { (result) -> Group in
                if let group = result {
                    return group
                } else {
                    throw Abort(.notFound)
                }
            }
        return findGroupFuture.flatMap { (group) -> EventLoopFuture<[User]> in
            return req.groupUserRepository.findUsers(group)
        }
    }
    
    func indexGroups(_ req: Request) throws -> EventLoopFuture<[Group]> {
        
        guard let userIDString = req.parameters.get("user_id"),
              let userID = User.IDValue(userIDString)
        else {throw Abort(.notFound)}
        
        let findUserFuture = req.userRepository.find(id: userID)
            .flatMapThrowing { (result) -> User in
                if let user = result {
                    return user
                } else {
                    throw Abort(.notFound)
                }
            }
        
        return findUserFuture.flatMap { (user) -> EventLoopFuture<[Group]> in
            return req.groupUserRepository.findGroups(user)
        }
        
    }
}
