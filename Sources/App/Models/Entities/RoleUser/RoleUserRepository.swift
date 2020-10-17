import Vapor

protocol RoleUserRepository {
    func findUsers(_ role: Role) -> EventLoopFuture<[User]>
    func findRoles(_ user: User) -> EventLoopFuture<[Role]>
    func findPivot(_ roleID: Role.IDValue, _ userID: User.IDValue) -> EventLoopFuture<RoleUser?>
    func delete(_ pivot: RoleUser)-> EventLoopFuture<Void>
    func create(_ pivot: RoleUser)-> EventLoopFuture<RoleUser>
}
