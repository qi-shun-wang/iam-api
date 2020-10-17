import Fluent

final class PSQLUserRepository{//}: UserRepository {
    typealias DB = Database
    
    let db: DB
    
    init(_ db: DB) {
        self.db = db
    }
    
//    func save(user: User) -> EventLoopFuture<User> {
//        
//        return db.withConnection { conn in
//            
//            
//            return user.save(on: conn)
//        }
//    }
//    
//    func find(accountID: String) -> EventLoopFuture<User?> {
//        return db.withConnection { conn in
//            return User.findOne(by: [\.accountID == accountID], on: conn, withSoftDeleted: false)
//        }
//    }
//    
//    func find(id: Int) -> EventLoopFuture<User?> {
//        return db.withConnection { conn in
//            return User.findOne(by: [\.id == id], on: conn, withSoftDeleted: false)
//        }
//    }
//    
//    func all() -> EventLoopFuture<[User]> {
//        return db.withConnection { conn in
//            return User.query(on: conn).all()
//        }
//    }
//    
//    func delete(user: User) -> EventLoopFuture<Void> {
//        return db.withConnection { conn in
//            return user.delete(on: conn)
//        }
//    }
}
