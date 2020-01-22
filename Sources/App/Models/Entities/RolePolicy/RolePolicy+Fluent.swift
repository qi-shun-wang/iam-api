import FluentPostgreSQL

extension RolePolicy: PostgreSQLPivot {
    static var entity = "role_policy"
    typealias Left = Role
    typealias Right = Policy
    
    static var leftIDKey: LeftIDKey = \.roleID
    static var rightIDKey: RightIDKey = \.policyID
    
    static var createdAtKey: TimestampKey? = \.createdAt
    static var deletedAtKey: TimestampKey? = \.deletedAt
    static var updatedAtKey: TimestampKey? = \.updatedAt
}

extension RolePolicy: Migration {}

extension RolePolicy: ModifiablePivot {}
