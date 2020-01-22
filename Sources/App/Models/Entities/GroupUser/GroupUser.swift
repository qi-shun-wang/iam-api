import Foundation

final class GroupUser: Codable {
    var id: Int?
    
    var groupID: Int
    var userID: Int
    
    var createdAt: Date?
    var updatedAt: Date?
    var deletedAt: Date?
    
    init(id: Int? = nil
        ,groupID: Int
        ,userID: Int
        ) {
        self.id = id
        self.groupID = groupID
        self.userID = userID
    }
    
    init(_ left: Group, _ right: User) throws {
        self.groupID = try left.requireID()
        self.userID = try right.requireID()
    }
}
