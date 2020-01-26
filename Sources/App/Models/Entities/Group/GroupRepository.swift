import Vapor

protocol GroupRepository: Service {
    func save(group: Group) -> EventLoopFuture<Group>
    func find(id: Int) -> EventLoopFuture<Group?>
    func all() -> EventLoopFuture<[Group]>
    func delete(group: Group) -> EventLoopFuture<Void>
}
