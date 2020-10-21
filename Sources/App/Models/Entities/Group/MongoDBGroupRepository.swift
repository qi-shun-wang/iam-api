import Fluent

struct MongoDBGroupRepository: GroupRepository {
    typealias DB = Database
    
    let db: DB

    func save(group: Group) -> EventLoopFuture<Group> {
        return db.withConnection { conn in
            return group.save(on: conn).flatMapThrowing { () -> Group in
                return group
            }
        }
    }
    
    func find(id: Group.IDValue) -> EventLoopFuture<Group?> {
        return db.withConnection { conn in
            return Group.query(on: conn).filter(\.$id == id).first()
        }
    }
    
    func all() -> EventLoopFuture<[Group]> {
        return db.withConnection { conn in
            return Group.query(on: conn).all()
        }
    }
    
    func delete(group: Group) -> EventLoopFuture<Void> {
        return db.withConnection { conn in
            return group.delete(on: conn)
        }
    }
    
}
