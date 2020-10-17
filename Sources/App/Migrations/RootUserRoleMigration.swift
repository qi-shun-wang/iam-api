//import Fluent
//
//struct RootUserRoleMigration: PostgreSQLMigration {
//    
//    static func prepare(on conn: PostgreSQLConnection) -> EventLoopFuture<Void> {
//        return User
//            .query(on: conn)
//            .filter(\.accountID, .equal, "root")
//            .first()
//            .flatMap { result  in
//                guard let user = result else {
//                    return .done(on: conn)
//                }
//                return Role.query(on: conn).filter(\.type, .equal, "root").first().flatMap { result in
//                    guard let role = result else {
//                        return .done(on: conn)
//                    }
//                    return role.users.isAttached(user, on: conn).flatMap { isAttached in
//                        if isAttached {
//                            return .done(on: conn)
//                        } else {
//                            return role.users.attach(user, on: conn).transform(to: ())
//                        }
//                    }
//                }
//        }
//    }
//    
//    static func revert(on conn: PostgreSQLConnection) -> EventLoopFuture<Void> {
//        return .done(on: conn)
//    }
//}
