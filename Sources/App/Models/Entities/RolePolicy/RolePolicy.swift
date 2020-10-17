import Fluent

final class RolePolicy: Model {
    
    static var schema: String = "role_policy"
    
    @ID(key: .id)
    var id: Int?
    
    @Parent(key: "role_id")
    var role: Role
    
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
    
    init(id: Int? = nil,  role: Role,policy: Policy) throws {
        self.id = id
        self.$role.id = try role.requireID()
        self.$policy.id = try policy.requireID()
    }
    
    
}
