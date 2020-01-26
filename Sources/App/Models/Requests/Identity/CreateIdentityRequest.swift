import Foundation

struct CreateIdentityRequest: Codable {
    let role: String
    let accountID: String
    let password: String
}
