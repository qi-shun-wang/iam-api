import Fluent

struct GroupMigration: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("groups")
            .field("id", .uuid, .identifier(auto: false))
            .field("name", .string, .required)
            .unique(on: "name")
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("groups").delete()
    }
}
