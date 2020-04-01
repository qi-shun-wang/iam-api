import FluentPostgreSQL

extension RoleUser: PostgreSQLPivot {
    static var entity = "role_user"
    typealias Left = Role
    typealias Right = User
    
    static var leftIDKey: LeftIDKey = \.roleID
    static var rightIDKey: RightIDKey = \.userID
    
    static var createdAtKey: TimestampKey? = \.createdAt
    static var deletedAtKey: TimestampKey? = \.deletedAt
    static var updatedAtKey: TimestampKey? = \.updatedAt
}

extension RoleUser: PostgreSQLMigration {}

extension RoleUser: ModifiablePivot {}
