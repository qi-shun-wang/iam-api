import Foundation
import Fluent

final class GroupPolicy: Model {
    
    static var schema: String = "group_policy"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "group_id")
    var group: Group
    
    @Parent(key: "policy_id")
    var policy: Policy
    // When this GroupPolicy was created.
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    // When this GroupPolicy was last updated.
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    @Timestamp(key: "deleted_at", on: .delete)
    var deletedAt: Date?

    init() {}
    
    init(id: GroupPolicy.IDValue? = nil, group: Group, policy: Policy) throws {
        self.id = id
        self.$group.id = try group.requireID()
        self.$policy.id = try policy.requireID()
    }
    
}
