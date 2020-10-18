import Fluent

struct GroupPolicyMigration: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("group_policy")
            .field("id", .uuid, .identifier(auto: false))
            .field("group_id", .uuid, .required, .references("groups", "id"))
            .field("policy_id", .uuid, .required, .references("policies", "id"))
            .unique(on: "group_id", "policy_id")
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("group_policy").delete()
    }
}
