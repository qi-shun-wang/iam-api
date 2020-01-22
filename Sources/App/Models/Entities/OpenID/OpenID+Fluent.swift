import FluentPostgreSQL

extension OpenID: PostgreSQLModel { }
extension OpenID: Migration { }
extension OpenID {
    var user: Parent<OpenID, User> {
        return parent(\.userID)
    }
}
