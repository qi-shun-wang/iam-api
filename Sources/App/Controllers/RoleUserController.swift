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
    
    func boot(router: Router) throws {
        let allowedPolicy = User.IAMAuthPolicyMiddleware(allowed: [IAMPolicyIdentifier.root])
        let roles = router.grouped("roles").grouped(allowedPolicy)
        let users = router.grouped("users").grouped(allowedPolicy)
        users.get(User.ID.parameter, "roles", use: indexRoles)
        roles.get(Role.ID.parameter, "users", use: indexUsers)
        roles.delete(Role.ID.parameter, "users", User.ID.parameter, use: delete)
        roles.post(Role.ID.parameter, "users", User.ID.parameter, use: create)
    }
    
    func create(_ req: Request) throws -> Future<HTTPResponse> {
        let roleID = try req.parameters.next(Role.ID.self)
        let userID = try req.parameters.next(User.ID.self)
        return self.roleUserRepository.findPivot(roleID, userID).flatMap { result in
            if result == nil {
                return self.roleUserRepository
                    .create(RoleUser(roleID: roleID, userID: userID))
                    .transform(to: HTTPResponse(status: .ok))
            }
            return req.future(HTTPResponse(status: .ok))
        }
    }
    
    func delete(_ req: Request) throws -> Future<HTTPResponse> {
        let roleID = try req.parameters.next(Role.ID.self)
        let userID = try req.parameters.next(User.ID.self)
        return self.roleUserRepository.findPivot(roleID, userID).flatMap { result in
            if let pivot = result {
                return self.roleUserRepository
                    .delete(pivot)
                    .transform(to: HTTPResponse(status: .ok))
            }
            return req.future(HTTPResponse(status: .ok))
        }
    }
    
    func indexUsers(_ req: Request) throws -> Future<[User]> {
        let roleID = try req.parameters.next(Role.ID.self)
        return roleRepository.find(id: roleID).flatMap { (result) -> EventLoopFuture<[User]> in
            guard let role = result else {throw Abort(HTTPResponseStatus.notFound)}
            return self.roleUserRepository.findUsers(role)
        }
    }
    
    func indexRoles(_ req: Request) throws -> Future<[Role]> {
        let userID = try req.parameters.next(User.ID.self)
        return userRepository.find(id: userID).flatMap { (result) -> EventLoopFuture<[Role]> in
            guard let user = result else {throw Abort(HTTPResponseStatus.notFound)}
            return self.roleUserRepository.findRoles(user)
        }
    }
}
