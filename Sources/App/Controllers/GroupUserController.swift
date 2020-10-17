import Vapor


final class GroupUserController: RouteCollection {
    private let groupUserRepository: GroupUserRepository
    private let groupRepository: GroupRepository
    private let userRepository: UserRepository
    
    init(groupRepository: GroupRepository,
         userRepository: UserRepository,
         groupUserRepository: GroupUserRepository) {
        self.groupRepository = groupRepository
        self.userRepository = userRepository
        self.groupUserRepository = groupUserRepository
    }
    
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
        let findGroupFuture = groupRepository.find(id: groupID)
            .flatMapThrowing { (result) -> Group in
                if let group = result {
                    return group
                } else {
                    throw Abort(.notFound)
                }
            }
        let findUserFuture = userRepository.find(id: userID)
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
            let createPivotFuture =   self.groupUserRepository.findPivot(newPivot.group.id!, newPivot.user.id!)
                .flatMap { (result) -> EventLoopFuture<GroupUser> in
                    if let pivot = result {
                        return req.eventLoop.future(pivot)
                    } else {
                        return self.groupUserRepository.create(newPivot)
                        
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
            return self.groupUserRepository.findPivot(newPivot.group.id!, newPivot.user.id!)
                .flatMapThrowing { (result) -> GroupUser in
                    if let pivot = result {
                        return pivot
                    } else {
                        throw Abort(.notFound)
                    }
                }
        }
        let responseFuture = findPivotFuture.flatMap { (pivot) -> EventLoopFuture<Response> in
            return self.groupUserRepository.delete(pivot).transform(to: Response(status:.ok))
        }
        
        return responseFuture
    }
    
    func indexUsers(_ req: Request) throws -> EventLoopFuture<[User]> {
        
        guard let groupIDString = req.parameters.get("group_id"),
              let groupID = Int(groupIDString)
        else {throw Abort(.notFound)}
        let findGroupFuture = groupRepository.find(id: groupID)
            .flatMapThrowing { (result) -> Group in
                if let group = result {
                    return group
                } else {
                    throw Abort(.notFound)
                }
            }
        return findGroupFuture.flatMap { (group) -> EventLoopFuture<[User]> in
            return self.groupUserRepository.findUsers(group)
        }
    }
    
    func indexGroups(_ req: Request) throws -> EventLoopFuture<[Group]> {
        
        guard let userIDString = req.parameters.get("user_id"),
              let userID = User.IDValue(userIDString)
        else {throw Abort(.notFound)}
        
        let findUserFuture = userRepository.find(id: userID)
            .flatMapThrowing { (result) -> User in
                if let user = result {
                    return user
                } else {
                    throw Abort(.notFound)
                }
            }
        
        return findUserFuture.flatMap { (user) -> EventLoopFuture<[Group]> in
            return self.groupUserRepository.findGroups(user)
        }
        
    }
}
