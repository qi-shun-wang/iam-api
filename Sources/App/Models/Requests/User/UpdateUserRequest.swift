import Foundation

struct UpdateUserRequest: Codable {
    let accountID: String?
    let password: String?
}
