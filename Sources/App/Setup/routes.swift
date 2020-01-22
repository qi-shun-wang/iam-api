import Vapor

public func routes(_ router: Router, _ container: Container) throws {
    let v1 = router.grouped("v1")
    try v1.register(collection: UserController(userRepository: container.make()))
    try v1.register(collection: PolicyController(policyRepository: container.make()))
    try v1.register(collection: GroupController(groupRepository: container.make()))
    try v1.register(collection: RoleController(roleRepository: container.make()))
    
    try v1.register(collection: OpenIDController(openIDRepository: container.make()))
    
    try v1.register(collection: GroupPolicyController(groupPolicyRepository: container.make()))
    try v1.register(collection: GroupUserController(groupUserRepository: container.make()))
    try v1.register(collection: RolePolicyController(rolePolicyRepository: container.make()))
    try v1.register(collection: RoleUserController(roleUserRepository: container.make()))
    try v1.register(collection: HealthController())
}
