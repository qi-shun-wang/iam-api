import Vapor 

final class RoleController: RouteCollection {
    private let roleRepository: RoleRepository
    
    init(roleRepository: RoleRepository) {
        self.roleRepository = roleRepository
    }
    
    func boot(router: Router) throws {
        let allowedPolicy = Application.IAMAuthPolicyMiddleware(allowed: [IAMPolicyIdentifier.root])
        let roles = router.grouped("roles").grouped(allowedPolicy)
        roles.post(use: create)
        roles.get(use: index)
        roles.get(Role.ID.parameter, use: select)
        roles.put(Role.ID.parameter, use: update)
        roles.delete(Role.ID.parameter, use: delete)
    }
    
    func create( _ req: Request) throws -> Future<Role> {
        return try req.content.decode(CreateRoleRequest.self).flatMap { form  in
            return self.roleRepository.save(role: Role(type: form.type))
        }
    }
    
    func select( _ req: Request) throws -> Future<Role> {
        let id = try req.parameters.next(Role.ID.self)
        return self.roleRepository.find(id: id).map { result in
            guard let role = result else { throw Abort(HTTPResponseStatus.notFound) }
            return role
        }
    }
    
    func index( _ req: Request) throws -> Future<[Role]> {
        return self.roleRepository.all()
    }
    
    func update( _ req: Request) throws -> Future<Role> {
        let roleID = try req.parameters.next(Role.ID.self)
        let roleFuture = self.roleRepository.find(id: roleID)
            .map { (result) -> Role in
                guard let role = result else { throw Abort(.notFound)}
                return role
        }
        return roleFuture.flatMap { role in
            return try req.content.decode(UpdateRoleRequest.self).flatMap { form  in
                if let new = form.type {
                    role.type = new
                }
                return self.roleRepository.save(role: role)
            }
        }
    }
    
    func delete( _ req: Request) throws -> Future<HTTPResponse> {
        let roleID = try req.parameters.next(Role.ID.self)
        let roleFuture = self.roleRepository.find(id: roleID)
            .map { (result) -> Role in
                guard let role = result else { throw Abort(.notFound)}
                return role
        }
        return roleFuture.flatMap { role in
            return self.roleRepository.delete(role: role).transform(to: HTTPResponse(status: .ok))
        }
        
    }
}
