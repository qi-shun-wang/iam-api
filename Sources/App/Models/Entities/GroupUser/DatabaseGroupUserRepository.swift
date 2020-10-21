import Fluent

struct DatabaseGroupUserRepository: GroupUserRepository {
    let db: Database
    
    func findUsers(_ group: Group) -> EventLoopFuture<[User]> {
        return db.withConnection { conn -> EventLoopFuture<[User]> in
            return group.$users.query(on: conn).all()
        }
    }
    
    func findGroups(_ user: User) -> EventLoopFuture<[Group]> {
        return db.withConnection { conn -> EventLoopFuture<[Group]> in
            return user.$groups.query(on: conn).all()
        }
    }
    
    func findPivot(_ group: Group, _ user: User) -> EventLoopFuture<GroupUser?> {
        let groupID = try? group.requireID()
        let userID = try? user.requireID()
        
        if groupID == nil && userID == nil{return db.eventLoop.future(nil)}
        return db.withConnection { conn in
            return GroupUser
                .query(on: conn)
                .filter("group_id", .equal, groupID!)
                .filter("user_id", .equal, userID!)
                .first()
        }
    }
    
    func delete(_ pivot: GroupUser) -> EventLoopFuture<Void> {
        return db.withConnection { (conn) -> EventLoopFuture<Void> in
            return pivot.delete(force: true, on: conn)
        }
    }
    
    func create(_ pivot: GroupUser) -> EventLoopFuture<GroupUser> {
        return db.withConnection { (conn) -> EventLoopFuture<GroupUser> in
            return pivot.create(on: conn).transform(to: pivot)
        }
    }
}
