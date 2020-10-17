import Fluent
import Fluent

final class PSQLRolePolicyRepository{//}: RolePolicyRepository {
    typealias DB = Database
    
    let db: DB
    
    init(_ db: DB) {
        self.db = db
    }
    
//    func findPolicies(in roles: [Role]) -> EventLoopFuture<[Policy]> {
//        return db.withConnection { conn -> EventLoopFuture<[Policy]> in
//            let builder = RolePolicy.query(on: conn)
//            let a:[Int] = roles.map{$0.id!}
//            return builder
//                .filter(\.roleID ~~ a)
//                .join(\Policy.id, to: \RolePolicy.policyID)
//                .alsoDecode(Policy.self)
//                .all()
//                .map { (result) -> [Policy] in
//                    return result.map { (pivot, p) -> Policy in
//                        return p
//                    }
//            }
//        }
//    }
//    
//    func findPolicies(_ role: Role) -> EventLoopFuture<[Policy]> {
//        return db.withConnection { conn -> EventLoopFuture<[Policy]> in
//            return try role.policies.query(on: conn).all()
//        }
//    }
//    
//    func findRoles(_ policy: Policy) -> EventLoopFuture<[Role]> {
//        return db.withConnection { conn -> EventLoopFuture<[Role]> in
//            return try policy.roles.query(on: conn).all()
//        }
//    }
//    
//    func findPivot(_ roleID: Int, _ policyID: Int) -> EventLoopFuture<RolePolicy?> {
//        return db.withConnection { conn in
//            return RolePolicy.findOne(by: [\.roleID == roleID, \.policyID == policyID], on: conn)
//        }
//    }
//    
//    func delete(_ pivot: RolePolicy) -> EventLoopFuture<Void> {
//        return db.withConnection { (conn) -> EventLoopFuture<Void> in
//            return pivot.delete(force: true, on: conn)
//        }
//    }
//    
//    func create(_ pivot: RolePolicy) -> EventLoopFuture<RolePolicy> {
//        return db.withConnection { (conn) -> EventLoopFuture<RolePolicy> in
//            return pivot.create(on: conn)
//        }
//    }
    
}
