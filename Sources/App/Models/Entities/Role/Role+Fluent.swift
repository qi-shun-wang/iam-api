import FluentPostgreSQL

extension Role: PostgreSQLModel {
    static var entity = "roles"
}
extension Role: Migration { }
extension Role {
    var policies: Siblings<Role, Policy, RolePolicy> {
        return siblings()
    }
    var users: Siblings<Role, User, RoleUser> {
        return siblings()
    }
}
