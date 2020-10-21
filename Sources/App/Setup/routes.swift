import Vapor

public func routes(_ app: Application) throws {
    
    let v1 = app.routes.grouped("v1")
    try v1.register(collection: HealthController())
    try v1.register(collection: UserController())
    try v1.register(collection: GroupController())
    try v1.register(collection: PolicyController())
    try v1.register(collection: RoleController())
    try v1.register(collection: RoleUserController())
    try v1.register(collection: RolePolicyController())
    try v1.register(collection: GroupUserController())
    try v1.register(collection: GroupPolicyController())
}
