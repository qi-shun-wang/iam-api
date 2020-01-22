import Foundation

final class RoleUser: Codable {
    var id: Int?
    
    var roleID: Int
    var userID: Int
    
    var createdAt: Date?
    var updatedAt: Date?
    var deletedAt: Date?
    
    init(id: Int? = nil
        ,roleID: Int
        ,userID: Int
        ) {
        self.id = id
        self.roleID = roleID
        self.userID = userID
    }
    
    init(_ left: Role, _ right: User) throws {
        self.roleID = try left.requireID()
        self.userID = try right.requireID()
    }
}
