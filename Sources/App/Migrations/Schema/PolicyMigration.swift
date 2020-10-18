import Fluent

struct PolicyMigration: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("policies")
            .field("id", .uuid, .identifier(auto: false))
            .field("key", .string, .required)
            .field("json", .string)
            .unique(on: "key")
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("policies").delete()
    }
}
