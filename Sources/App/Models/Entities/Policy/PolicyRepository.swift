import Vapor

protocol PolicyRepository {
    func save(policy: Policy) -> EventLoopFuture<Policy>
    func find(id: Policy.IDValue) -> EventLoopFuture<Policy?>
    func all() -> EventLoopFuture<[Policy]>
    func delete(policy: Policy) -> EventLoopFuture<Void>
}
