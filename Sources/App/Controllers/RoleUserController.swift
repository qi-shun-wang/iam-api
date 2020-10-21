import Vapor

final class RoleUserController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        //        let allowedPolicy = Application.IAMAuthPolicyMiddleware(allowed: [IAMPolicyIdentifier.root])
        let roles = routes.grouped("roles")//.grouped(allowedPolicy)
        let users = routes.grouped("users")//.grouped(allowedPolicy)
        users.get(":id", "roles", use: indexRoles)
        roles.get(":id", "users", use: indexUsers)
        roles.delete(":id", "users", ":user_id", use: delete)
        roles.post(":id", "users", ":user_id", use: create)
    }
    
    func selectRoleAndUser(_ req: Request) throws -> EventLoopFuture<RoleUser> {
        guard let roleIDString = req.parameters.get("id"),
              let userIDString = req.parameters.get("user_id"),
              let roleID = Role.IDValue(roleIDString),
              let userID = User.IDValue(userIDString)
        else {throw Abort(.notFound)}
        let findRoleFuture = req.roleRepository.find(id: roleID)
            .flatMapThrowing { (result) -> Role in
                if let role = result {
                    return role
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
        
        let pivotFuture = findRoleFuture
            .and(findUserFuture)
            .flatMapThrowing { (role, user) -> RoleUser in
                return try RoleUser(role: role, user: user)
            }
        return pivotFuture
    }
    
    func create(_ req: Request) throws -> EventLoopFuture<Response> {
        let selectRoleAndUserFuture = try selectRoleAndUser(req)
        
        let findPivotFuture = selectRoleAndUserFuture.flatMap { (newPivot) -> EventLoopFuture<RoleUser> in
            let createPivotFuture = req.roleUserRepository
                .findPivot(newPivot.role, newPivot.user)
                .flatMap { (result) -> EventLoopFuture<RoleUser> in
                    if let pivot = result {
                        return req.eventLoop.future(pivot)
                    } else {
                        return req.roleUserRepository.create(newPivot)
                        
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
        let selectRoleAndUserFuture = try selectRoleAndUser(req)
        
        let findPivotFuture = selectRoleAndUserFuture.flatMap { (newPivot) -> EventLoopFuture<RoleUser> in
            return req.roleUserRepository
                .findPivot(newPivot.role, newPivot.user)
                .flatMapThrowing { (result) -> RoleUser in
                    if let pivot = result {
                        return pivot
                    } else {
                        throw Abort(.notFound)
                    }
                }
        }
        let responseFuture = findPivotFuture.flatMap { (pivot) -> EventLoopFuture<Response> in
            return req.roleUserRepository.delete(pivot).transform(to: Response(status:.ok))
        }
        
        return responseFuture
    }
    
    func indexUsers(_ req: Request) throws -> EventLoopFuture<[User]> {
        guard let roleIDString = req.parameters.get("id"),
              let roleID = Role.IDValue(roleIDString)
        else {throw Abort(.notFound)}
        let findRoleFuture = req.roleRepository.find(id: roleID)
            .flatMapThrowing { (result) -> Role in
                if let role = result {
                    return role
                } else {
                    throw Abort(.notFound)
                }
            }
        return findRoleFuture.flatMap { (role) -> EventLoopFuture<[User]> in
            return req.roleUserRepository.findUsers(role)
        }
    }
    
    func indexRoles(_ req: Request) throws -> EventLoopFuture<[Role]> {
        guard let userIDString = req.parameters.get("id"),
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
        
        return findUserFuture.flatMap { (user) -> EventLoopFuture<[Role]> in
            return req.roleUserRepository.findRoles(user)
        }
    }
}
