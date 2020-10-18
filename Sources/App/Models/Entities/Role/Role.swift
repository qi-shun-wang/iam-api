import Foundation
import Fluent

final class Role: Model {
    
    static var schema: String = "roles"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "type")
    var type: String
    
    init() {}
    
    init(id: Role.IDValue? = nil, type: String) {
        self.id = id
        self.type = type
    }
    
}
