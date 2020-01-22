import Foundation

final class RolePolicy: Codable {
    var id: Int?
    
    var roleID: Int
    var policyID: Int
    
    var createdAt: Date?
    var updatedAt: Date?
    var deletedAt: Date?
    
    init(id: Int? = nil
        ,roleID: Int
        ,policyID: Int
        ) {
        self.id = id
        self.roleID = roleID
        self.policyID = policyID
    }
    
    init(_ left: Role, _ right: Policy) throws {
        self.roleID = try left.requireID()
        self.policyID = try right.requireID()
    }
}
