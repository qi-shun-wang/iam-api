import Vapor

struct CheckIdentityResponse: Content {
    let id: Int
    let groups: [String]
    let roles: [String]
    let policies: [String]
}
