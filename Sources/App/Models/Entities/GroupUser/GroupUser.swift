import Fluent

final class GroupUser: Model {
    
    static var schema: String = "group_user"
    
    @ID(key: .id)
    var id: Int?
    
    @Parent(key: "group_id")
    var group: Group
    
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
    
    init(id: Int? = nil, group: Group, user: User) throws {
        self.id = id
        self.$group.id = try group.requireID()
        self.$user.id = try user.requireID()
    }
    
     
}
