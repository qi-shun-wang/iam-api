import Fluent
import Fluent

final class PSQLGroupPolicyRepository{//: GroupPolicyRepository {
    
    typealias DB = Database
    
    let db: DB
    
    init(_ db: DB) {
        self.db = db
    }
    
//    func findPolicies(in groups: [Group]) -> EventLoopFuture<[Policy]> {
//        return db.withConnection { conn -> EventLoopFuture<[Policy]> in
//            let builder = GroupPolicy.query(on: conn)
//            let a:[Int] = groups.map{$0.id!}
//            return builder
//                .filter(\.groupID ~~ a)//Need import Fluent
//                .join(\Policy.id, to: \GroupPolicy.policyID)
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
//    func findPolicies(_ group: Group) -> EventLoopFuture<[Policy]> {
//        return db.withConnection { conn -> EventLoopFuture<[Policy]> in
//            return try group.policies.query(on: conn).all()
//        }
//    }
//    
//    func findGroups(_ policy: Policy) -> EventLoopFuture<[Group]> {
//        return db.withConnection { conn -> EventLoopFuture<[Group]> in
//            return try policy.groups.query(on: conn).all()
//        }
//    }
//    
//    func findPivot(_ groupID: Int, _ policyID: Int) -> EventLoopFuture<GroupPolicy?> {
//        return db.withConnection { conn in
//            return GroupPolicy.findOne(by: [\.groupID == groupID, \.policyID == policyID], on: conn)
//        }
//    }
//    
//    func delete(_ pivot: GroupPolicy) -> EventLoopFuture<Void> {
//        return db.withConnection { (conn) -> EventLoopFuture<Void> in
//            return pivot.delete(force: true, on: conn)
//        }
//    }
//    
//    func create(_ pivot: GroupPolicy) -> EventLoopFuture<GroupPolicy> {
//        return db.withConnection { (conn) -> EventLoopFuture<GroupPolicy> in
//            return pivot.create(on: conn)
//        }
//    }
}
