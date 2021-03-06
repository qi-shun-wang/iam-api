import Fluent

struct RolePolicyMigration: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("role_policy")
            .field("id", .uuid, .identifier(auto: false))
            .field("role_id", .uuid, .required, .references("roles", "id"))
            .field("policy_id", .uuid, .required, .references("policies", "id"))
            .field("created_at",.datetime, .required)
            .field("updated_at",.datetime, .required)
            .field("deleted_at",.datetime)
            .unique(on: "role_id", "policy_id")
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("role_policy").delete()
    }
}
