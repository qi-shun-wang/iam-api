import Vapor

struct CheckIdentityResponse: Content {
    let groups: [String]
    let roles: [String]
    let policies: [String]
}
