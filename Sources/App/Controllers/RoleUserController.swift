import Vapor

final class RoleUserController: RouteCollection {
    private let roleUserRepository: RoleUserRepository
    private let roleRepository: RoleRepository
    private let userRepository: UserRepository
    
    init(roleRepository: RoleRepository,
         userRepository: UserRepository,
         roleUserRepository: RoleUserRepository) {
        self.roleRepository = roleRepository
        self.userRepository = userRepository
        self.roleUserRepository = roleUserRepository
    }
    
    func boot(routes: RoutesBuilder) throws {
        //        let allowedPolicy = Application.IAMAuthPolicyMiddleware(allowed: [IAMPolicyIdentifier.root])
        let roles = routes.grouped("roles")//.grouped(allowedPolicy)
        let users = routes.grouped("users")//.grouped(allowedPolicy)
        users.get(":user_id", "roles", use: indexRoles)
        roles.get(":role_id", "users", use: indexUsers)
        roles.delete(":role_id", "users", ":user_id", use: delete)
        roles.post(":role_id", "users", ":user_id", use: create)
    }
    
    func selectRoleAndUser(_ req: Request) throws -> EventLoopFuture<RoleUser> {
        guard let roleIDString = req.parameters.get("role_id"),
              let userIDString = req.parameters.get("user_id"),
              let roleID = Int(roleIDString),
              let userID = UUID(userIDString)
        else {throw Abort(.notFound)}
        let findRoleFuture = roleRepository.find(id: roleID)
            .flatMapThrowing { (result) -> Role in
                if let role = result {
                    return role
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
            let createPivotFuture = self.roleUserRepository
                .findPivot(newPivot.role.id!, newPivot.user.id!)
                .flatMap { (result) -> EventLoopFuture<RoleUser> in
                    if let pivot = result {
                        return req.eventLoop.future(pivot)
                    } else {
                        return self.roleUserRepository.create(newPivot)
                        
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
            return self.roleUserRepository
                .findPivot(newPivot.role.id!, newPivot.user.id!)
                .flatMapThrowing { (result) -> RoleUser in
                    if let pivot = result {
                        return pivot
                    } else {
                        throw Abort(.notFound)
                    }
                }
        }
        let responseFuture = findPivotFuture.flatMap { (pivot) -> EventLoopFuture<Response> in
            return self.roleUserRepository.delete(pivot).transform(to: Response(status:.ok))
        }
        
        return responseFuture
    }
    
    func indexUsers(_ req: Request) throws -> EventLoopFuture<[User]> {
        guard let roleIDString = req.parameters.get("role_id"),
              let roleID = Int(roleIDString)
        else {throw Abort(.notFound)}
        let findRoleFuture = roleRepository.find(id: roleID)
            .flatMapThrowing { (result) -> Role in
                if let role = result {
                    return role
                } else {
                    throw Abort(.notFound)
                }
            }
        return findRoleFuture.flatMap { (role) -> EventLoopFuture<[User]> in
            return self.roleUserRepository.findUsers(role)
        }
    }
    
    func indexRoles(_ req: Request) throws -> EventLoopFuture<[Role]> {
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
        
        return findUserFuture.flatMap { (user) -> EventLoopFuture<[Role]> in
            return self.roleUserRepository.findRoles(user)
        }
    }
}
