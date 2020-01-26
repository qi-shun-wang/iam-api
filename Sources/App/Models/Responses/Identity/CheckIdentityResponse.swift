import Vapor

struct CheckIdentityResponse: Content {
    let id: User.ID
    let groups: [String]
    let roles: [String]
    let policies: [String]
}
