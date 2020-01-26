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
    
    func boot(router: Router) throws {
        let groups = router.grouped("groups")
        let policies = router.grouped("policies")
        policies.get(Policy.ID.parameter, "groups", use: indexGroups)
        groups.get(Group.ID.parameter, "policies", use: indexPolicies)
        groups.delete(Group.ID.parameter, "policies", Policy.ID.parameter, use: delete)
        groups.post(Group.ID.parameter, "policies", Policy.ID.parameter, use: create)
    }
    
    func create(_ req: Request) throws -> Future<HTTPResponse> {
        let groupID = try req.parameters.next(Group.ID.self)
        let policyID = try req.parameters.next(Policy.ID.self)
        return self.groupPolicyRepository.findPivot(groupID, policyID).flatMap { result in
            if result == nil {
                return self.groupPolicyRepository
                    .create(GroupPolicy(groupID: groupID, policyID: policyID))
                    .transform(to: HTTPResponse(status: .ok))
            }
            return req.future(HTTPResponse(status: .ok))
        }
    }
    
    func delete(_ req: Request) throws -> Future<HTTPResponse> {
        let groupID = try req.parameters.next(Group.ID.self)
        let policyID = try req.parameters.next(Policy.ID.self)
        return self.groupPolicyRepository.findPivot(groupID, policyID).flatMap { result in
            if let pivot = result {
                return self.groupPolicyRepository
                    .delete(pivot)
                    .transform(to: HTTPResponse(status: .ok))
            }
            
            return req.future(HTTPResponse(status: .ok))
        }
    }
    
    func indexPolicies(_ req: Request) throws -> Future<[Policy]> {
        let groupID = try req.parameters.next(Group.ID.self)
        return groupRepository.find(id: groupID).flatMap { (result) -> EventLoopFuture<[Policy]> in
            guard let group = result else {throw Abort(HTTPResponseStatus.notFound)}
            return self.groupPolicyRepository.findPolicies(group)
        }
    }
    
    func indexGroups(_ req: Request) throws -> Future<[Group]> {
        let policyID = try req.parameters.next(Policy.ID.self)
        return policyRepository.find(id: policyID).flatMap { (result) -> EventLoopFuture<[Group]> in
            guard let policy = result else {throw Abort(HTTPResponseStatus.notFound)}
            return self.groupPolicyRepository.findGroups(policy)
        }
    }
}
