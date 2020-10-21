import Fluent

struct DatabaseRoleRepository: RoleRepository {
    let db: Database
    
    func save(role: Role) -> EventLoopFuture<Role> {
        return db.withConnection { conn in
            return role.save(on: conn).flatMapThrowing { () -> Role in
                return role
            }
        }
    }
    
    func find(id: Role.IDValue) -> EventLoopFuture<Role?> {
        return db.withConnection { conn in
            return Role
                .query(on: conn)
                .filter(\.$id == id)
                .first()
        }
    }
    
    func find(type: String) -> EventLoopFuture<Role?> {
        return db.withConnection { conn in
            return Role
                .query(on: conn)
                .filter(\.$type == type)
                .first()
        }
    }
    
    func all() -> EventLoopFuture<[Role]> {
        return db.withConnection { conn in
            return Role.query(on: conn).all()
        }
    }
    
    func delete(role: Role) -> EventLoopFuture<Void> {
        return db.withConnection { conn in
            return role.delete(on: conn)
        }
    }
    
}
