import Fluent

final class PSQLRoleRepository{//}: RoleRepository {
    typealias DB = Database
    
    let db: DB
    
    init(_ db: DB) {
        self.db = db
    }
    
//    func save(role: Role) -> EventLoopFuture<Role> {
//        return db.withConnection { conn in
//            return role.save(on: conn)
//        }
//    }
//    
//    func find(id: Int) -> EventLoopFuture<Role?> {
//        return db.withConnection { conn in
//            return Role.findOne(by: [\.id == id], on: conn, withSoftDeleted: false)
//        }
//    }
//    
//    func find(type: String) -> EventLoopFuture<Role?> {
//        return db.withConnection { conn in
//            return Role.findOne(by: [\.type == type], on: conn, withSoftDeleted: false)
//        }
//    }
//    
//    func all() -> EventLoopFuture<[Role]> {
//        return db.withConnection { conn in
//            return Role.query(on: conn).all()
//        }
//    }
//    
//    func delete(role: Role) -> EventLoopFuture<Void> {
//        return db.withConnection { conn in
//            return role.delete(on: conn)
//        }
//    }
    
}
