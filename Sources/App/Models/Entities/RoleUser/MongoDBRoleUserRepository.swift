import Fluent

struct MongoDBRoleUserRepository: RoleUserRepository {
   
    typealias DB = Database
    
    let db: DB
    
    func findUsers(_ role: Role) -> EventLoopFuture<[User]> {
        return db.withConnection { conn -> EventLoopFuture<[User]> in
            return role.$users.query(on: conn).all()
        }
    }
    
    func findRoles(_ user: User) -> EventLoopFuture<[Role]> {
        return db.withConnection { conn -> EventLoopFuture<[Role]> in
            return user.$roles.query(on: conn).all()
        }
    }
    
    func findPivot(_ role: Role, _ user: User) -> EventLoopFuture<RoleUser?> {
        let roleID = try? role.requireID()
        let userID = try? user.requireID()
        
        if userID == nil && roleID == nil{return db.eventLoop.future(nil)}
        return db.withConnection { conn in
            
            return RoleUser
                .query(on: conn)
                .filter("user_id", .equal, userID!)
                .filter("role_id", .equal, roleID!)
                .first()
        }
    }
    
    func delete(_ pivot: RoleUser) -> EventLoopFuture<Void> {
        return db.withConnection { (conn) -> EventLoopFuture<Void> in
            return pivot.delete(force: true, on: conn)
        }
    }
    
    func create(_ pivot: RoleUser) -> EventLoopFuture<RoleUser> {
        return db.withConnection { (conn) -> EventLoopFuture<RoleUser> in
            return pivot.create(on: conn).transform(to: pivot)
        }
    }
    
}
