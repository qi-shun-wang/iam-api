import Fluent

final class RoleUser: Model {
    
    static var schema: String = "role_user"
    
    @ID(key: .id)
    var id: Int?
    
    @Parent(key: "role_id")
    var role: Role
    
    @Parent(key: "user_id")
    var user: User
    
    // When this GroupPolicy was created.
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    // When this GroupPolicy was last updated.
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    @Timestamp(key: "deleted_at", on: .delete)
    var deletedAt: Date?
    
    init() {}
    
    init(id: Int? = nil,  role: Role,user: User) throws {
        self.id = id
        self.$role.id = try role.requireID()
        self.$user.id = try user.requireID()
    }
    
    
}
