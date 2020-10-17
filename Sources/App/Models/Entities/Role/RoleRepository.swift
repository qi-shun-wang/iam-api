import Vapor

protocol RoleRepository {
    func save(role: Role) -> EventLoopFuture<Role>
    func find(id: Int) -> EventLoopFuture<Role?>
    func find(type: String) -> EventLoopFuture<Role?>
    func all() -> EventLoopFuture<[Role]>
    func delete(role: Role) -> EventLoopFuture<Void>
}
