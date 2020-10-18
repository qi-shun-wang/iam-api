import Vapor 

final class GroupPolicyController: RouteCollection {
    private let groupPolicyRepository: GroupPolicyRepository
    private let groupRepository: GroupRepository
    private let policyRepository: PolicyRepository
    
    init(groupRepository: GroupRepository,
         policyRepository: PolicyRepository,
         groupPolicyRepository: GroupPolicyRepository) {
        self.groupRepository = groupRepository
        self.policyRepository = policyRepository
        self.groupPolicyRepository = groupPolicyRepository
    }
    
    func boot(routes: RoutesBuilder) throws {
        //        let allowedPolicy = Application.IAMAuthPolicyMiddleware(allowed: [IAMPolicyIdentifier.root])
        let groups = routes.grouped("groups")//.grouped(allowedPolicy)
        let policies = routes.grouped("policies")//.grouped(allowedPolicy)
        policies.get(":policy_id", "groups", use: indexGroups)
        groups.get(":group_id", "policies", use: indexPolicies)
        groups.delete(":group_id", "policies", ":policy_id", use: delete)
        groups.post(":group_id", "policies", ":policy_id", use: create)
    }
    
    func selectGroupAndPolicy(_ req: Request) throws -> EventLoopFuture<GroupPolicy> {
        guard let groupIDString = req.parameters.get("group_id"),
              let policyIDString = req.parameters.get("policy_id"),
              let groupID = Group.IDValue(groupIDString),
              let policyID = Policy.IDValue(policyIDString)
        else {throw Abort(.notFound)}
        let findGroupFuture = groupRepository.find(id: groupID)
            .flatMapThrowing { (result) -> Group in
                if let group = result {
                    return group
                } else {
                    throw Abort(.notFound)
                }
            }
        let findPolicyFuture = policyRepository.find(id: policyID)
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
            let createPivotFuture = self.groupPolicyRepository.findPivot(newPivot.group.id!, newPivot.policy.id!)
                .flatMap { (result) -> EventLoopFuture<GroupPolicy> in
                    if let pivot = result {
                        return req.eventLoop.future(pivot)
                    } else {
                        return self.groupPolicyRepository.create(newPivot)
                        
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
            return self.groupPolicyRepository.findPivot(newPivot.group.id!, newPivot.policy.id!)
                .flatMapThrowing { (result) -> GroupPolicy in
                    if let pivot = result {
                        return pivot
                    } else {
                        throw Abort(.notFound)
                    }
                }
        }
        let responseFuture = findPivotFuture.flatMap { (pivot) -> EventLoopFuture<Response> in
            return self.groupPolicyRepository.delete(pivot).transform(to: Response(status:.ok))
        }
        
        return responseFuture
        
    }
    
    func indexPolicies(_ req: Request) throws -> EventLoopFuture<[Policy]> {
        guard let groupIDString = req.parameters.get("group_id"),
              let groupID = Group.IDValue(groupIDString)
        else {throw Abort(.notFound)}
        let findGroupFuture = groupRepository.find(id: groupID)
            .flatMapThrowing { (result) -> Group in
                if let group = result {
                    return group
                } else {
                    throw Abort(.notFound)
                }
            }
        return findGroupFuture.flatMap { (group) -> EventLoopFuture<[Policy]> in
            return self.groupPolicyRepository.findPolicies(group)
        }
    }
    
    func indexGroups(_ req: Request) throws -> EventLoopFuture<[Group]> {
        guard let policyIDString = req.parameters.get("policy_id"),
              let policyID = Policy.IDValue(policyIDString)
        else {throw Abort(.notFound)}
        
        let findPolicyFuture = policyRepository.find(id: policyID)
            .flatMapThrowing { (result) -> Policy in
                if let policy = result {
                    return policy
                } else {
                    throw Abort(.notFound)
                }
            }
        
        return findPolicyFuture.flatMap { (policy) -> EventLoopFuture<[Group]> in
            return self.groupPolicyRepository.findGroups(policy)
        }
        
        
    }
}
