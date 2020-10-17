import Fluent

final class PSQLRoleUserRepository{//}: RoleUserRepository {
    typealias DB = Database
    
    let db: DB
    
    init(_ db: DB) {
        self.db = db
    }
    
//    func findUsers(_ role: Role) -> EventLoopFuture<[User]> {
//        return db.withConnection { conn -> EventLoopFuture<[User]> in
//            return try role.users.query(on: conn).all()
//        }
//    }
//    
//    func findRoles(_ user: User) -> EventLoopFuture<[Role]> {
//        return db.withConnection { conn -> EventLoopFuture<[Role]> in
//            return try user.roles.query(on: conn).all()
//        }
//    }
//    
//    func findPivot(_ roleID: Int, _ userID: Int) -> EventLoopFuture<RoleUser?> {
//        return db.withConnection { conn in
//            return RoleUser.findOne(by: [\.roleID == roleID, \.userID == userID], on: conn)
//        }
//    }
//    
//    func delete(_ pivot: RoleUser) -> EventLoopFuture<Void> {
//        return db.withConnection { (conn) -> EventLoopFuture<Void> in
//            return pivot.delete(force: true, on: conn)
//        }
//    }
//    
//    func create(_ pivot: RoleUser) -> EventLoopFuture<RoleUser> {
//        return db.withConnection { (conn) -> EventLoopFuture<RoleUser> in
//            return pivot.create(on: conn)
//        }
//    }
    
}
