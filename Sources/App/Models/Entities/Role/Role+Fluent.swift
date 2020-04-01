import FluentPostgreSQL

extension Role: PostgreSQLModel {
    static var entity = "roles"
}
extension Role: PostgreSQLMigration { }
extension Role {
    var policies: Siblings<Role, Policy, RolePolicy> {
        return siblings()
    }
    var users: Siblings<Role, User, RoleUser> {
        return siblings()
    }
}
