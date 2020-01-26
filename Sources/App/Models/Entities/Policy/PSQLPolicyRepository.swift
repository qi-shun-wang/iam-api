import FluentPostgreSQL

final class PSQLPolicyRepository: PolicyRepository {
    typealias DB = DatabaseConnectionPool<ConfiguredDatabase<PostgreSQLDatabase>>
    let db:DB
    

    init(_ db: DB) {
        self.db = db
    }

    func save(policy: Policy) -> EventLoopFuture<Policy> {
        return db.withConnection { conn in
            return policy.save(on: conn)
        }
    }
    
    func find(id: Int) -> EventLoopFuture<Policy?> {
        return db.withConnection { conn in
            return Policy.findOne(by: [\.id == id], on: conn, withSoftDeleted: false)
        }
    }
    
    func all() -> EventLoopFuture<[Policy]> {
        return db.withConnection { conn in
            return Policy.query(on: conn).all()
        }
    }
    
    func delete(policy: Policy) -> EventLoopFuture<Void> {
        return db.withConnection { conn in
            return policy.delete(on: conn)
        }
    }
}
