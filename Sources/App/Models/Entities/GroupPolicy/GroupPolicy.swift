import Foundation

final class GroupPolicy: Codable {
    var id: Int?
    
    var groupID: Int
    var policyID: Int
    
    var createdAt: Date?
    var updatedAt: Date?
    var deletedAt: Date?
    
    init(id: Int? = nil
        ,groupID: Int
        ,policyID: Int
        ) {
        self.id = id
        self.groupID = groupID
        self.policyID = policyID
    }
    
    init(_ left: Group, _ right: Policy) throws {
        self.groupID = try left.requireID()
        self.policyID = try right.requireID()
    }
}
