import FluentPostgreSQL

extension User: PostgreSQLModel {
    static var entity = "users"
}
extension User: Migration { }
extension User {
    var openIDs: Children<User, OpenID> {
        return children(\.userID)
    }
    var roles: Siblings<User, Role, RoleUser> {
        return siblings()
    }
    var groups: Siblings<User, Group, GroupUser> {
        return siblings()
    }
}

extension User {
    public struct TokenForm: Codable {
        let token: String
    }
}
