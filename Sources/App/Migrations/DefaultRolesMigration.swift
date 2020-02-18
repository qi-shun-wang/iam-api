import FluentPostgreSQL

struct DefaultRolesMigration: PostgreSQLMigration {
    static func prepare(on conn: PostgreSQLConnection) -> EventLoopFuture<Void> {
        let rootRole = Role(type: "root")
        let userRole = Role(type: "user")
        let adminRole = Role(type: "admin")
        return rootRole.save(on: conn).then {_ in
            return adminRole.save(on: conn).then {_ in
                return userRole.save(on: conn).transform(to: ())
            }
        }
    }
    
    static func revert(on conn: PostgreSQLConnection) -> EventLoopFuture<Void> {
        return .done(on: conn)
    }
}
