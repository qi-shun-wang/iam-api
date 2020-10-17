import Fluent

struct UserMigration: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users")
            .field("id", .uuid, .identifier(auto: false))
            .field("account_id", .string, .required)
            .field("password", .string, .required)
            .field("access_id", .string, .required)
            .field("access_key", .string, .required)
            .unique(on: "account_id")
            .unique(on: "access_id")
            .unique(on: "access_key")
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users").delete()
    }
}
