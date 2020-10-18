import Fluent

struct RoleMigration: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("roles")
            .field("id", .uuid, .identifier(auto: false))
            .field("type", .string, .required)
            .unique(on: "type")
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("roles").delete()
    }
}
