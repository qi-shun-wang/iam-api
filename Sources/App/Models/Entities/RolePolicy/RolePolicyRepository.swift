import Vapor

protocol RolePolicyRepository {
    func findPolicies(in roles: [Role]) -> EventLoopFuture<[Policy]>
    func findPolicies(_ role: Role) -> EventLoopFuture<[Policy]>
    func findRoles(_ policy: Policy) -> EventLoopFuture<[Role]>
    func findPivot(_ roleID: Role.IDValue,_ policyID: Policy.IDValue) -> EventLoopFuture<RolePolicy?>
    func delete(_ pivot: RolePolicy)-> EventLoopFuture<Void>
    func create(_ pivot: RolePolicy)-> EventLoopFuture<RolePolicy>
}
