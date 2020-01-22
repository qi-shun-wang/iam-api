final class Policy: Codable {
    var id: Int?
    
    var key: String
    var json: String

    init(id: Int? = nil, key: String, json: String) {
        self.id = id
        self.key = key
        self.json = json
    }
}
