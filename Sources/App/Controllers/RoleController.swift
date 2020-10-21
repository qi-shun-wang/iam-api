import Vapor 

final class RoleController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        //        let allowedPolicy = Application.IAMAuthPolicyMiddleware(allowed: [IAMPolicyIdentifier.root])
        let roles = routes.grouped("roles")//.grouped(allowedPolicy)
        roles.post(use: create)
        roles.get(use: index)
        roles.get(":id", use: select)
        roles.put(":id", use: update)
        roles.delete(":id", use: delete)
    }
    
    func create( _ req: Request) throws -> EventLoopFuture<Role> {
        let form = try req.content.decode(CreateRoleRequest.self)
        
        return req.roleRepository.save(role: Role(type: form.type))
    }
    
    func select( _ req: Request) throws -> EventLoopFuture<Role> {
        guard let idString = req.parameters.get("id"),
              let id = Role.IDValue(idString)
        else {throw Abort(.notFound)}
        
        let findRoleFuture = req.roleRepository.find(id: id)
            .flatMapThrowing { (result) -> Role in
                if let role = result {
                    return role
                } else {
                    throw Abort(.notFound)
                }
            }
        
        return findRoleFuture
    }
    
    func index( _ req: Request) throws -> EventLoopFuture<[Role]> {
        return req.roleRepository.all()
    }
    
    func update( _ req: Request) throws -> EventLoopFuture<Role> {
        let form = try req.content.decode(UpdateRoleRequest.self)
        
        let findRoleFuture = try select(req)
        
        let updateRoleFuture = findRoleFuture
            .flatMap { (role) -> EventLoopFuture<Role> in
                if let new = form.type {
                    role.type = new
                }
                return req.roleRepository.save(role: role)
            }
        return updateRoleFuture
    }
    
    func delete( _ req: Request) throws -> EventLoopFuture<Response> {
        let findRoleFuture = try select(req)
        
        let deleteRoleFuture = findRoleFuture
            .flatMap { (role) -> EventLoopFuture<Response> in
                return req.roleRepository.delete(role: role)
                    .transform(to: Response(status: .ok))
            }
        
        return deleteRoleFuture
    }
}
