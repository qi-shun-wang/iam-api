import Vapor

protocol RoleUserRepository: Service {
    func findUsers(_ role: Role) -> EventLoopFuture<[User]>
    func findRoles(_ user: User) -> EventLoopFuture<[Role]>
    func findPivot(_ roleID: Int,_ userID: Int) -> EventLoopFuture<RoleUser?>
    func delete(_ pivot: RoleUser)-> EventLoopFuture<Void>
    func create(_ pivot: RoleUser)-> EventLoopFuture<RoleUser>
}
