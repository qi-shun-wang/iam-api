import Vapor 

final class GroupPolicyController: RouteCollection {
   
    func boot(routes: RoutesBuilder) throws {
        //        let allowedPolicy = Application.IAMAuthPolicyMiddleware(allowed: [IAMPolicyIdentifier.root])
        let groups = routes.grouped("groups")//.grouped(allowedPolicy)
        let policies = routes.grouped("policies")//.grouped(allowedPolicy)
        policies.get(":id", "groups", use: indexGroups)
        groups.get(":id", "policies", use: indexPolicies)
        groups.delete(":id", "policies", ":policy_id", use: delete)
        groups.post(":id", "policies", ":policy_id", use: create)
    }
    
    func selectGroupAndPolicy(_ req: Request) throws -> EventLoopFuture<GroupPolicy> {
        guard let groupIDString = req.parameters.get("id"),
              let policyIDString = req.parameters.get("policy_id"),
              let groupID = Group.IDValue(groupIDString),
              let policyID = Policy.IDValue(policyIDString)
        else {throw Abort(.notFound)}
        let findGroupFuture = req.groupRepository.find(id: groupID)
            .flatMapThrowing { (result) -> Group in
                if let group = result {
                    return group
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
        
        let pivotFuture = findGroupFuture
            .and(findPolicyFuture)
            .flatMapThrowing { (group, policy) -> GroupPolicy in
                return try GroupPolicy(group: group, policy: policy)
            }
        return pivotFuture
    }
    
    func create(_ req: Request) throws -> EventLoopFuture<Response> {
        let selectGroupPolicyFuture = try selectGroupAndPolicy(req)
        
        let findPivotFuture = selectGroupPolicyFuture.flatMap { (newPivot) -> EventLoopFuture<GroupPolicy> in
            let createPivotFuture = req.groupPolicyRepository.findPivot(newPivot.group, newPivot.policy)
                .flatMap { (result) -> EventLoopFuture<GroupPolicy> in
                    if let pivot = result {
                        return req.eventLoop.future(pivot)
                    } else {
                        return req.groupPolicyRepository.create(newPivot)
                        
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
        let selectGroupPolicyFuture = try selectGroupAndPolicy(req)
        
        let findPivotFuture = selectGroupPolicyFuture.flatMap { (newPivot) -> EventLoopFuture<GroupPolicy> in
            return req.groupPolicyRepository.findPivot(newPivot.group, newPivot.policy)
                .flatMapThrowing { (result) -> GroupPolicy in
                    if let pivot = result {
                        return pivot
                    } else {
                        throw Abort(.notFound)
                    }
                }
        }
        let responseFuture = findPivotFuture.flatMap { (pivot) -> EventLoopFuture<Response> in
            return req.groupPolicyRepository.delete(pivot).transform(to: Response(status:.ok))
        }
        
        return responseFuture
        
    }
    
    func indexPolicies(_ req: Request) throws -> EventLoopFuture<[Policy]> {
        guard let groupIDString = req.parameters.get("id"),
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
        return findGroupFuture.flatMap { (group) -> EventLoopFuture<[Policy]> in
            return req.groupPolicyRepository.findPolicies(group)
        }
    }
    
    func indexGroups(_ req: Request) throws -> EventLoopFuture<[Group]> {
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
        
        return findPolicyFuture.flatMap { (policy) -> EventLoopFuture<[Group]> in
            return req.groupPolicyRepository.findGroups(policy)
        }
        
        
    }
}
