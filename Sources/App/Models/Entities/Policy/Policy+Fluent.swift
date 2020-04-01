import FluentPostgreSQL

extension Policy: PostgreSQLModel {
    static var entity = "policies"
}
extension Policy: PostgreSQLMigration { }
extension Policy {
    var roles: Siblings<Policy, Role, RolePolicy> {
        return siblings()
    }
    var groups: Siblings<Policy, Group, GroupPolicy> {
        return siblings()
    }
}
