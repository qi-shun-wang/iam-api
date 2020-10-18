import Fluent

struct RoleUserMigration: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("role_user")
            .field("id", .uuid, .identifier(auto: false))
            .field("role_id", .uuid, .required, .references("roles", "id"))
            .field("user_id", .uuid, .required, .references("users", "id"))
            .unique(on: "role_id", "user_id")
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("role_user").delete()
    }
}
