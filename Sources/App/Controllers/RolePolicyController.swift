import Vapor

final class RolePolicyController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        //        let allowedPolicy = Application.IAMAuthPolicyMiddleware(allowed: [IAMPolicyIdentifier.root])
        let roles = routes.grouped("roles")//.roleed(allowedPolicy)
        let policies = routes.grouped("policies")//.roleed(allowedPolicy)
        policies.get(":id", "roles", use: indexRoles)
        roles.get(":id", "policies", use: indexPolicies)
        roles.delete(":id", "policies", ":policy_id", use: delete)
        roles.post(":id", "policies", ":policy_id", use: create)
    }
    
    func selectRoleAndPolicy(_ req: Request) throws -> EventLoopFuture<RolePolicy> {
        guard let roleIDString = req.parameters.get("id"),
              let policyIDString = req.parameters.get("policy_id"),
              let roleID = Role.IDValue(roleIDString),
              let policyID = Policy.IDValue(policyIDString)
        else {throw Abort(.notFound)}
        let findRoleFuture = req.roleRepository.find(id: roleID)
            .flatMapThrowing { (result) -> Role in
                if let role = result {
                    return role
                } else {
                    throw Abort(.notFound)
                }
            }
        let findPolicyFuture = req.policyRepository.find(id: policyID)
            .flatMapThrowing { (result) -> Policy in
                if let policy = result {
                    return policy
                } else {
                    throw Abort(.notFound)
                }
            }
        
        let pivotFuture = findRoleFuture
            .and(findPolicyFuture)
            .flatMapThrowing { (role, policy) -> RolePolicy in
                return try RolePolicy(role: role, policy: policy)
            }
        return pivotFuture
    }
    
    
    func create(_ req: Request) throws -> EventLoopFuture<Response> {
        let selectRoleAndPolicyFuture = try selectRoleAndPolicy(req)
        
        let findPivotFuture = selectRoleAndPolicyFuture.flatMap { (newPivot) -> EventLoopFuture<RolePolicy> in
            let createPivotFuture = req.rolePolicyRepository.findPivot(newPivot.role, newPivot.policy)
                .flatMap { (result) -> EventLoopFuture<RolePolicy> in
                    if let pivot = result {
                        return req.eventLoop.future(pivot)
                    } else {
                        return req.rolePolicyRepository.create(newPivot)
                        
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
        let selectRoleAndPolicyFuture = try selectRoleAndPolicy(req)
        
        let findPivotFuture = selectRoleAndPolicyFuture.flatMap { (newPivot) -> EventLoopFuture<RolePolicy> in
            return req.rolePolicyRepository.findPivot(newPivot.role, newPivot.policy)
                .flatMapThrowing { (result) -> RolePolicy in
                    if let pivot = result {
                        return pivot
                    } else {
                        throw Abort(.notFound)
                    }
                }
        }
        let responseFuture = findPivotFuture.flatMap { (pivot) -> EventLoopFuture<Response> in
            return req.rolePolicyRepository.delete(pivot).transform(to: Response(status:.ok))
        }
        
        return responseFuture
    }
    
    func indexPolicies(_ req: Request) throws -> EventLoopFuture<[Policy]> {
        
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
        return findRoleFuture.flatMap { (role) -> EventLoopFuture<[Policy]> in
            return req.rolePolicyRepository.findPolicies(role)
        }
    }
    
    func indexRoles(_ req: Request) throws -> EventLoopFuture<[Role]> {
        
        guard let policyIDString = req.parameters.get("id"),
              let policyID = Policy.IDValue(policyIDString)
        else {throw Abort(.notFound)}
        
        let findPolicyFuture = req.policyRepository.find(id: policyID)
            .flatMapThrowing { (result) -> Policy in
                if let policy = result {
                    return policy
                } else {
                    throw Abort(.notFound)
                }
            }
        
        return findPolicyFuture.flatMap { (policy) -> EventLoopFuture<[Role]> in
            return req.rolePolicyRepository.findRoles(policy)
        }
        
    }
}
