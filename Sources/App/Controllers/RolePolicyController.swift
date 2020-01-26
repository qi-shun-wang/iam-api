import Vapor

final class RolePolicyController: RouteCollection {
    private let rolePolicyRepository: RolePolicyRepository
    private let roleRepository: RoleRepository
    private let policyRepository: PolicyRepository
    
    init(roleRepository: RoleRepository,
         policyRepository: PolicyRepository,
         rolePolicyRepository: RolePolicyRepository) {
        self.roleRepository = roleRepository
        self.policyRepository = policyRepository
        self.rolePolicyRepository = rolePolicyRepository
    }
    
    func boot(router: Router) throws {
        let roles = router.grouped("roles")
        let policies = router.grouped("policies")
        policies.get(Policy.ID.parameter, "roles", use: indexRoles)
        roles.get(Role.ID.parameter, "policies", use: indexPolicies)
        roles.delete(Role.ID.parameter, "policies", Policy.ID.parameter, use: delete)
        roles.post(Role.ID.parameter, "policies", Policy.ID.parameter, use: create)
    }
    
    func create(_ req: Request) throws -> Future<HTTPResponse> {
        let roleID = try req.parameters.next(Role.ID.self)
        let policyID = try req.parameters.next(Policy.ID.self)
        return self.rolePolicyRepository.findPivot(roleID, policyID).flatMap { result in
            if result == nil {
                return self.rolePolicyRepository
                    .create(RolePolicy(roleID: roleID, policyID: policyID))
                    .transform(to: HTTPResponse(status: .ok))
            }
            return req.future(HTTPResponse(status: .ok))
        }
    }
    
    func delete(_ req: Request) throws -> Future<HTTPResponse> {
        let roleID = try req.parameters.next(Role.ID.self)
        let policyID = try req.parameters.next(Policy.ID.self)
        return self.rolePolicyRepository.findPivot(roleID, policyID).flatMap { result in
            if let pivot = result {
                return self.rolePolicyRepository
                    .delete(pivot)
                    .transform(to: HTTPResponse(status: .ok))
            }
            
            return req.future(HTTPResponse(status: .ok))
        }
    }
    
    func indexPolicies(_ req: Request) throws -> Future<[Policy]> {
        let roleID = try req.parameters.next(Role.ID.self)
        return roleRepository.find(id: roleID).flatMap { (result) -> EventLoopFuture<[Policy]> in
            guard let role = result else {throw Abort(HTTPResponseStatus.notFound)}
            return self.rolePolicyRepository.findPolicies(role)
        }
    }
    
    func indexRoles(_ req: Request) throws -> Future<[Role]> {
        let policyID = try req.parameters.next(Policy.ID.self)
        return policyRepository.find(id: policyID).flatMap { (result) -> EventLoopFuture<[Role]> in
            guard let policy = result else {throw Abort(HTTPResponseStatus.notFound)}
            return self.rolePolicyRepository.findRoles(policy)
        }
    }
}
