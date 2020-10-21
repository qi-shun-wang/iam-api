import Fluent

struct MongoDBRolePolicyRepository: RolePolicyRepository {
    typealias DB = Database
    
    let db: DB
    
//    func findPolicies(in roles: [Role]) -> EventLoopFuture<[Policy]> {
//        return db.withConnection { conn -> EventLoopFuture<[Policy]> in
//            let builder = RolePolicy.query(on: conn)
//                .filter("role_id", .subset(inverse: false),roles)
//
//                .with(\.$policy)
//                .all()
////            let a:[Int] = roles.map{$0.id!}
////            return builder
////                .filter(\.role =~ roles)
////                .join(\Policy.id, to: \RolePolicy.policyID)
////                .alsoDecode(Policy.self)
////                .all()
////                .map { (result) -> [Policy] in
////                    return result.map { (pivot, p) -> Policy in
////                        return p
////                    }
////            }
//        }
//    }
    
    func findPolicies(_ role: Role) -> EventLoopFuture<[Policy]> {
        return db.withConnection { conn -> EventLoopFuture<[Policy]> in
            return role.$policies.query(on: conn).all()
        }
    }
    
    func findRoles(_ policy: Policy) -> EventLoopFuture<[Role]> {
        return db.withConnection { conn -> EventLoopFuture<[Role]> in
            return policy.$roles.query(on: conn).all()
        }
    }
    
    func findPivot(_ role: Role, _ policy: Policy) -> EventLoopFuture<RolePolicy?> {
        
        let roleID = try? role.requireID()
        let policyID = try? policy.requireID()
        
        if roleID == nil && policyID == nil{return db.eventLoop.future(nil)}
        return db.withConnection { conn in
            return RolePolicy
                .query(on: conn)
                .filter("role_id", .equal, roleID!)
                .filter("policy_id", .equal, policyID!)
                .first()
        }
    }
    
    func delete(_ pivot: RolePolicy) -> EventLoopFuture<Void> {
        return db.withConnection { (conn) -> EventLoopFuture<Void> in
            return pivot.delete(force: true, on: conn)
        }
    }
    
    func create(_ pivot: RolePolicy) -> EventLoopFuture<RolePolicy> {
        return db.withConnection { (conn) -> EventLoopFuture<RolePolicy> in
            return pivot.create(on: conn).transform(to: pivot)
        }
    }
    
}
