import Fluent

struct DefaultPoliciesMigration: Migration {
    
    let rootPolicy = Policy(key: "ROOT", json: "{\"key\":\"ROOT\"}")
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return rootPolicy.create(on: database)
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return Policy.query(on: database).filter(\.$key, .equal, rootPolicy.key).first().flatMap { (result) -> EventLoopFuture<Void> in
            if let root = result {
                return root.delete(on: database)
            } else {
                database.logger.error("ROOT policy key doesn't exist.")
                return database.eventLoop.future()
            }
        }
    }
}

