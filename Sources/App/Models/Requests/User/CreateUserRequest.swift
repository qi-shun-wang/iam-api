import Foundation

struct CreateUserRequest: Codable {
    let accountID: String
    let password: String
}
