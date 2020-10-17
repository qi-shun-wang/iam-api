import Foundation
import Fluent

final class MongoDBUserRepository: UserRepository {
    typealias DB = Database
    
    let db: DB
    
    init(_ db: DB) {
        self.db = db
    }
    
    func save(user: User) -> EventLoopFuture<User> {
        return db.withConnection { conn in
            return user.save(on: conn).flatMapThrowing { () -> User in
                return user
            }
            
        }
    }
    
    func find(accountID: String) -> EventLoopFuture<User?> {
        return db.withConnection { conn in
            return User.query(on: conn).filter(\.$accountID == accountID).first()
        }
    }
    
    func find(id: UUID) -> EventLoopFuture<User?> {
        return db.withConnection { conn in
            return User.query(on: conn).filter(\.$id == id).first()
        }
    }
    
    func all() -> EventLoopFuture<[User]> {
        return db.withConnection { conn in
            return User.query(on: conn).all()
        }
    }
    
    func delete(user: User) -> EventLoopFuture<Void> {
        return db.withConnection { conn in
            return user.delete(on: conn)
        }
    }
}
