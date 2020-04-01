import FluentPostgreSQL

extension GroupUser: PostgreSQLPivot {
    static var entity = "group_user"
    typealias Left = Group
    typealias Right = User
    
    static var leftIDKey: LeftIDKey = \.groupID
    static var rightIDKey: RightIDKey = \.userID
    
    static var createdAtKey: TimestampKey? = \.createdAt
    static var deletedAtKey: TimestampKey? = \.deletedAt
    static var updatedAtKey: TimestampKey? = \.updatedAt
}

extension GroupUser: PostgreSQLMigration {}

extension GroupUser: ModifiablePivot {}
