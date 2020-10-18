import Fluent

struct DefaultRolesMigration: Migration {
    let rootRole = Role(type: "root")
    let userRole = Role(type: "user")
    let adminRole = Role(type: "admin")
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        let createRootRoleFuture = rootRole.create(on: database)
        let createUserRoleFuture = userRole.create(on: database)
        let createAdminRoleFuture = adminRole.create(on: database)
        return createRootRoleFuture
            .and(createUserRoleFuture)
            .and(createAdminRoleFuture)
            .flatMap { (_) -> EventLoopFuture<Void> in
                return database.eventLoop.future()
            }
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        let deleteRootRoleFuture = Role.query(on: database).filter(\.$type, .equal, rootRole.type).first().flatMap { (result) -> EventLoopFuture<Void> in
            if let root = result {
                return root.delete(on: database)
            } else {
                database.logger.error("root role type doesn't exist.")
                return database.eventLoop.future()
            }
        }
        
        let deleteUserRoleFuture = Role.query(on: database).filter(\.$type, .equal, userRole.type).first().flatMap { (result) -> EventLoopFuture<Void> in
            if let user = result {
                return user.delete(on: database)
            } else {
                database.logger.error("user role type doesn't exist.")
                return database.eventLoop.future()
            }
        }
        
        let deleteAdminRoleFuture = Role.query(on: database).filter(\.$type, .equal, adminRole.type).first().flatMap { (result) -> EventLoopFuture<Void> in
            if let admin = result {
                return admin.delete(on: database)
            } else {
                database.logger.error("admin role type doesn't exist.")
                return database.eventLoop.future()
            }
        }
        
        return deleteRootRoleFuture
            .and(deleteUserRoleFuture)
            .and(deleteAdminRoleFuture)
            .flatMap { (_) -> EventLoopFuture<Void> in
                return database.eventLoop.future()
            }
        
    }
}

