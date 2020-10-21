import Vapor

protocol GroupPolicyRepository {
//    func findPolicies(in groups: [Group]) -> EventLoopFuture<[Policy]>
    func findPolicies(_ group: Group) -> EventLoopFuture<[Policy]>
    func findGroups(_ policy: Policy) -> EventLoopFuture<[Group]>
    func findPivot(_ group: Group, _ policy: Policy) -> EventLoopFuture<GroupPolicy?>
    func delete(_ pivot: GroupPolicy)-> EventLoopFuture<Void>
    func create(_ pivot: GroupPolicy)-> EventLoopFuture<GroupPolicy>
}
