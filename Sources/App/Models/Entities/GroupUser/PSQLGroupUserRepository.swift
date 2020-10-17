import Fluent

final class PSQLGroupUserRepository{//}: GroupUserRepository {
    typealias DB = Database
    
    let db: DB

    init(_ db: DB) {
        self.db = db
    }
//    func findUsers(_ group: Group) -> EventLoopFuture<[User]> {
//          return db.withConnection { conn -> EventLoopFuture<[User]> in
//              return try group.users.query(on: conn).all()
//          }
//      }
//      
//      func findGroups(_ user: User) -> EventLoopFuture<[Group]> {
//          return db.withConnection { conn -> EventLoopFuture<[Group]> in
//              return try user.groups.query(on: conn).all()
//          }
//      }
//      
//      func findPivot(_ groupID: Int, _ userID: Int) -> EventLoopFuture<GroupUser?> {
//          return db.withConnection { conn in
//              return GroupUser.findOne(by: [\.groupID == groupID, \.userID == userID], on: conn)
//          }
//      }
//      
//      func delete(_ pivot: GroupUser) -> EventLoopFuture<Void> {
//          return db.withConnection { (conn) -> EventLoopFuture<Void> in
//              return pivot.delete(force: true, on: conn)
//          }
//      }
//      
//      func create(_ pivot: GroupUser) -> EventLoopFuture<GroupUser> {
//          return db.withConnection { (conn) -> EventLoopFuture<GroupUser> in
//              return pivot.create(on: conn)
//          }
//      }
}
