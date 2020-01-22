import FluentPostgreSQL

final class PSQLPolicyRepository: PolicyRepository {
    typealias DB = DatabaseConnectionPool<ConfiguredDatabase<PostgreSQLDatabase>>
    let db:DB
    

    init(_ db: DB) {
        self.db = db
    }

    func find(id: Int) -> EventLoopFuture<Policy?> {
        return db.withConnection { conn in
            return Policy.find(id, on: conn)
        }
    }

    func all() -> EventLoopFuture<[Policy]> {
        return db.withConnection { conn in
            return Policy.query(on: conn).all()
        }
    }

    func find(email: String) -> EventLoopFuture<Policy?> {
        return db.withConnection { conn in
            return Policy.query(on: conn).first()
        }
    }

    func findCount(email: String) -> EventLoopFuture<Int> {
        return db.withConnection { conn in
            return Policy.query(on: conn).count()
        }
    }

    func save(user: Policy) -> EventLoopFuture<Policy> {
        return db.withConnection { conn in
            return user.save(on: conn)
        }
    }
}
