import Vapor

protocol UserRepository: Service {
    func save(user: User) -> EventLoopFuture<User>
    func find(id: Int) -> EventLoopFuture<User?>
    func find(accountID: String) -> EventLoopFuture<User?>
    func all() -> EventLoopFuture<[User]>
    func delete(user: User) -> EventLoopFuture<Void>
}
