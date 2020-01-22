final class Role: Codable {
    var id: Int?
    
    var type: String
    
    init(id: Int? = nil, type: String) {
        self.id = id
        self.type = type
    }
}
