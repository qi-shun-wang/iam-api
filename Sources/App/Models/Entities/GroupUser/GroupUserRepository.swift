import Vapor

protocol GroupUserRepository {
    func findUsers(_ group: Group) -> EventLoopFuture<[User]>
    func findGroups(_ user: User) -> EventLoopFuture<[Group]>
    func findPivot(_ groupID: Group.IDValue,_ userID: User.IDValue) -> EventLoopFuture<GroupUser?>
    func delete(_ pivot: GroupUser)-> EventLoopFuture<Void>
    func create(_ pivot: GroupUser)-> EventLoopFuture<GroupUser>
}
