import Vapor

protocol GroupRepository {
    func save(group: Group) -> EventLoopFuture<Group>
    func find(id: Group.IDValue) -> EventLoopFuture<Group?>
    func all() -> EventLoopFuture<[Group]>
    func delete(group: Group) -> EventLoopFuture<Void>
}
