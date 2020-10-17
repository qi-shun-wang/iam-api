import Vapor

protocol PolicyRepository {
    func save(policy: Policy) -> EventLoopFuture<Policy>
    func find(id: Int) -> EventLoopFuture<Policy?>
    func all() -> EventLoopFuture<[Policy]>
    func delete(policy: Policy) -> EventLoopFuture<Void>
}
