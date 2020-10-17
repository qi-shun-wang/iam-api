import Vapor

protocol UserRepository {
    func save(user: User) -> EventLoopFuture<User>
    func find(id: User.IDValue) -> EventLoopFuture<User?>
    func find(accountID: String) -> EventLoopFuture<User?>
    func all() -> EventLoopFuture<[User]>
    func delete(user: User) -> EventLoopFuture<Void>
}
