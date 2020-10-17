import Fluent

final class PSQLGroupRepository{//}: GroupRepository {
//    typealias DB = DatabaseConnectionPool<ConfiguredDatabase<PostgreSQLDatabase>>
//    
//    let db: DB
//    
//    init(_ db: DB) {
//        self.db = db
//    }
//    
//    func save(group: Group) -> EventLoopFuture<Group> {
//        return db.withConnection { conn in
//            return group.save(on: conn)
//        }
//    }
//    
//    func find(id: Int) -> EventLoopFuture<Group?> {
//        return db.withConnection { conn in
//            return Group.findOne(by: [\.id == id], on: conn, withSoftDeleted: false)
//        }
//    }
//    
//    func all() -> EventLoopFuture<[Group]> {
//        return db.withConnection { conn in
//            return Group.query(on: conn).all()
//        }
//    }
//    
//    func delete(group: Group) -> EventLoopFuture<Void> {
//        return db.withConnection { conn in
//            return group.delete(on: conn)
//        }
//    }
    
}
