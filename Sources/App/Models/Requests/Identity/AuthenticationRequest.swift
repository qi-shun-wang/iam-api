import Foundation

struct AuthenticationRequest: Codable {
    let accountID: String
    let password: String
}
