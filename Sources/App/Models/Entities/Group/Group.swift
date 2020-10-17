import Fluent

final class Group: Model {
    
    static var schema: String = "groups"
    
    @ID(key: .id)
    var id: Int?
    
    @Field(key: "name")
    var name: String

    init() {}
    
    init(id: Int? = nil, name: String) {
        self.id = id
        self.name = name
    }
}
