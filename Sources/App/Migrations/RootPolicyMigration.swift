import FluentPostgreSQL

struct RootPolicyMigration: PostgreSQLMigration {
    static func prepare(on conn: PostgreSQLConnection) -> EventLoopFuture<Void> {
        return Policy.query(on: conn).filter(\.key, .equal, "ROOT").first()
            .flatMap { result in
                guard result == nil else {return .done(on: conn)}
                let rootPolicy = Policy(key: "ROOT", json: "{\"key\":\"ROOT\"}")
                return rootPolicy.save(on: conn).transform(to: ())
        }
    }
    
    static func revert(on conn: PostgreSQLConnection) -> EventLoopFuture<Void> {
        return .done(on: conn)
    }
}
