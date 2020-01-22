import FluentPostgreSQL

extension User: PostgreSQLModel { }
extension User: Migration { }
extension User {
    var openIDs: Children<User, OpenID> {
        return children(\.userID)
    }
}
