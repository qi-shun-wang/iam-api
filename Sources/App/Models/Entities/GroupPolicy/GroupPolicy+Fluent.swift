import FluentPostgreSQL

extension GroupPolicy: PostgreSQLPivot {
    static var entity = "group_policy"
    typealias Left = Group
    typealias Right = Policy
    
    static var leftIDKey: LeftIDKey = \.groupID
    static var rightIDKey: RightIDKey = \.policyID
    
    static var createdAtKey: TimestampKey? = \.createdAt
    static var deletedAtKey: TimestampKey? = \.deletedAt
    static var updatedAtKey: TimestampKey? = \.updatedAt
}

extension GroupPolicy: Migration {}

extension GroupPolicy: ModifiablePivot {}
