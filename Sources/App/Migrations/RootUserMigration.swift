import Foundation
import Fluent

struct RootUserMigration: Migration {
    let root = User(accountID: "root",
                    password: "root",
                    accessID: UUID().uuidString,
                    accessKey: UUID().uuidString)
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return root.create(on: database)
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return User.query(on: database).filter(\.$accountID, .equal, root.accessID).first().flatMap { (result) -> EventLoopFuture<Void> in
            if let user = result {
                return user.delete(on: database)
            } else {
                return database.eventLoop.future()
            }
        }
    }
}
