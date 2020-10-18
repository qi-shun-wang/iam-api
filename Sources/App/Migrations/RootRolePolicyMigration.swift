import Fluent

struct RootRolePolicyMigration: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        let policyFuture = Policy.query(on: database).filter(\.$key, .equal, "ROOT").first()
        let roleFuture = Role.query(on: database).filter(\.$type, .equal, "root").first()
        return policyFuture.and(roleFuture).flatMap { (policy, role) -> EventLoopFuture<Void> in
            if let rootPolicy = policy,
               let rootRole = role {
                return RolePolicy.query(on: database)
                    .filter("role_id",.equal, try! rootRole.requireID())
                    .filter("policy_id",.equal, try! rootPolicy.requireID())
                    .withDeleted()
                    .first()
                    .flatMap { (pivot) -> EventLoopFuture<Void> in
                    if let _ = pivot {
                        return database.eventLoop.future()
                    } else {
                        return rootPolicy.$roles.attach(rootRole, on: database)
                    }
                }
                
            } else {
                database.logger.warning("root role type or ROOT policy doesn't exist.")
                return database.eventLoop.future()
            }
        }
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        let policyFuture = Policy.query(on: database).filter(\.$key, .equal, "ROOT").first()
        let roleFuture = Role.query(on: database).filter(\.$type, .equal, "root").first()
        
        return policyFuture.and(roleFuture).flatMap { (policy, role) -> EventLoopFuture<Void> in
            if let rootPolicy = policy,
               let rootRole = role {
                return RolePolicy.query(on: database)
                    .filter("role_id",.equal, try! rootRole.requireID())
                    .filter("policy_id",.equal, try! rootPolicy.requireID())
                    .withDeleted()
                    .first()
                    .flatMap { (pivot) -> EventLoopFuture<Void> in
                    if let rolePolicy = pivot {
                        return rolePolicy.delete(force: true, on: database)
                    } else {
                        return database.eventLoop.future()
                    }
                }
            } else {
                database.logger.warning("root role type or ROOT policy doesn't exist.")
                return database.eventLoop.future()
            }
        }
    }
    
}
