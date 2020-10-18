import Foundation
import Fluent

final class Group: Model {
    
    static var schema: String = "groups"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String

    init() {}
    
    init(id: Group.IDValue? = nil, name: String) {
        self.id = id
        self.name = name
    }
}
