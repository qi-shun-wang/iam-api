//import Fluent
//
//struct RootUserMigration: PostgreSQLMigration {
//    static func prepare(on conn: PostgreSQLConnection) -> EventLoopFuture<Void> {
//        let root = User(accountID: "root",
//                        password: "root",
//                        accessID: UUID().uuidString,
//                        accessKey: UUID().uuidString)
//        return root.save(on: conn).transform(to: ())
//    }
//    
//    static func revert(on conn: PostgreSQLConnection) -> EventLoopFuture<Void> {
//        return .done(on: conn)
//    }
//}
