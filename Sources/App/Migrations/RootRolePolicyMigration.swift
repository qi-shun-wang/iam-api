import FluentPostgreSQL

struct RootRolePolicyMigration: PostgreSQLMigration {
    
    static func prepare(on conn: PostgreSQLConnection) -> EventLoopFuture<Void> {
        return Policy.query(on: conn).filter(\.key, .equal, "ROOT").first()
            .flatMap { result  in
                guard let policy = result else {
                    return .done(on: conn)
                }
                return Role.query(on: conn).filter(\.type, .equal, "root").first().flatMap { result in
                    guard let role = result else {
                        return .done(on: conn)
                    }
                    return role.policies.isAttached(policy, on: conn).flatMap { isAttached in
                        if isAttached {
                            return .done(on: conn)
                        } else {
                            return role.policies.attach(policy, on: conn).transform(to: ())
                        }
                    }
                }
        }
    }
    
    static func revert(on conn: PostgreSQLConnection) -> EventLoopFuture<Void> {
        return .done(on: conn)
    }
}
