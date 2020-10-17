import Fluent

final class Policy: Model {
    static var schema: String = "policies"
    /// Creates a new, empty Policy.
    init() {}
    
    init(id: Int? = nil, key: String, json: String) {
        self.id = id
        self.key = key
        self.json = json
    }
    /// Unique identifier for this Policy.
    @ID(key: .id)
    var id: Int?
    
    @Field(key: "key")
    var key: String
    
    @Field(key: "json")
    var json: String

    @Siblings(through: RolePolicy.self, from: \.$policy, to: \.$role)
    public var roles: [Role]
    
    @Siblings(through: GroupPolicy.self, from: \.$policy, to: \.$group)
    public var tags: [Group]
    
}
