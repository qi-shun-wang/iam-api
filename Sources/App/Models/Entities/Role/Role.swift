import Fluent

final class Role: Model {
    
    static var schema: String = "roles"
    
    @ID(key: .id)
    var id: Int?
    
    @Field(key: "type")
    var type: String
    
    init() {}
    
    init(id: Int? = nil, type: String) {
        self.id = id
        self.type = type
    }
    
}
