import Vapor

protocol GroupPolicyRepository: Service {
    func findPolicies(in groups: [Group]) -> EventLoopFuture<[Policy]>
    func findPolicies(_ group: Group) -> EventLoopFuture<[Policy]>
    func findGroups(_ policy: Policy) -> EventLoopFuture<[Group]>
    func findPivot(_ groupID: Int,_ policyID: Int) -> EventLoopFuture<GroupPolicy?>
    func delete(_ pivot: GroupPolicy)-> EventLoopFuture<Void>
    func create(_ pivot: GroupPolicy)-> EventLoopFuture<GroupPolicy>
}
