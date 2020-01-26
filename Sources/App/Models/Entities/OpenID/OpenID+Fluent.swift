import FluentPostgreSQL

extension OpenID: PostgreSQLModel {
    static var entity = "openIDs"
}
extension OpenID: Migration { }
extension OpenID {
    var user: Parent<OpenID, User> {
        return parent(\.userID)
    }
}
