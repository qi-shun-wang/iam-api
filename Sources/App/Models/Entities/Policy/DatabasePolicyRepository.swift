import Fluent

struct DatabasePolicyRepository: PolicyRepository {
    let db: Database
    
    func save(policy: Policy) -> EventLoopFuture<Policy> {
        return db.withConnection { conn in
            return policy.save(on: conn).transform(to: policy)
        }
    }
    
    func find(id: Policy.IDValue) -> EventLoopFuture<Policy?> {
        return db.withConnection { conn in
            return Policy
                .query(on: conn)
                .filter(\.$id == id)
                .first()
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
