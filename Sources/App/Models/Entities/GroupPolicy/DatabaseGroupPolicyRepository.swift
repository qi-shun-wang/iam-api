import Fluent

struct DatabaseGroupPolicyRepository: GroupPolicyRepository {
    let db: Database
    
    
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
    //                }
    //        }
    //    }
    
    func findPolicies(_ group: Group) -> EventLoopFuture<[Policy]> {
        return db.withConnection { conn -> EventLoopFuture<[Policy]> in
            return group.$policies.query(on: conn).all()
        }
    }
    
    func findGroups(_ policy: Policy) -> EventLoopFuture<[Group]> {
        return db.withConnection { conn -> EventLoopFuture<[Group]> in
            return policy.$groups.query(on: conn).all()
        }
    }
    
    func findPivot(_ group: Group, _ policy: Policy) -> EventLoopFuture<GroupPolicy?> {
        let groupID = try? group.requireID()
        let policyID = try? policy.requireID()
        
        if groupID == nil && policyID == nil{return db.eventLoop.future(nil)}
        return db.withConnection { conn in
            return GroupPolicy
                .query(on: conn)
                .filter("group_id", .equal, groupID!)
                .filter("policy_id", .equal, policyID!)
                .first()
        }
    }
    
    func delete(_ pivot: GroupPolicy) -> EventLoopFuture<Void> {
        return db.withConnection { (conn) -> EventLoopFuture<Void> in
            return pivot.delete(force: true, on: conn)
        }
    }
    
    func create(_ pivot: GroupPolicy) -> EventLoopFuture<GroupPolicy> {
        return db.withConnection { (conn) -> EventLoopFuture<GroupPolicy> in
            return pivot.create(on: conn).transform(to: pivot)
        }
    }
}
