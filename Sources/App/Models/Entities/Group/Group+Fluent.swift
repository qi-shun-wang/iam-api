import FluentPostgreSQL

extension Group: PostgreSQLModel {
    static var entity = "groups"
}
extension Group: Migration { }
extension Group {
    var policies: Siblings<Group, Policy, GroupPolicy> {
        return siblings()
    }
    var users: Siblings<Group, User, GroupUser> {
        return siblings()
    }
}
