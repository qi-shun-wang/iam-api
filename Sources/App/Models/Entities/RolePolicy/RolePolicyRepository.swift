import Vapor

protocol RolePolicyRepository {
//    func findPolicies(in roles: [Role]) -> EventLoopFuture<[Policy]>
    func findPolicies(_ role: Role) -> EventLoopFuture<[Policy]>
    func findRoles(_ policy: Policy) -> EventLoopFuture<[Role]>
    func findPivot(_ role: Role,_ policy: Policy) -> EventLoopFuture<RolePolicy?>
    func delete(_ pivot: RolePolicy)-> EventLoopFuture<Void>
    func create(_ pivot: RolePolicy)-> EventLoopFuture<RolePolicy>
}
