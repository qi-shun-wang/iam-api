import Vapor

public func routes(_ router: Router, _ container: Container) throws {
    try router.register(collection: UserController(userRepository: container.make()))
    try router.register(collection: PolicyController(policyRepository: container.make()))
    try router.register(collection: GroupController(groupRepository: container.make()))
    try router.register(collection: RoleController(roleRepository: container.make()))
    
    try router.register(collection: OpenIDController(openIDRepository: container.make()))
    
    try router.register(collection: GroupPolicyController(groupPolicyRepository: container.make()))
    try router.register(collection: GroupUserController(groupUserRepository: container.make()))
    try router.register(collection: RolePolicyController(rolePolicyRepository: container.make()))
    try router.register(collection: RoleUserController(roleUserRepository: container.make()))    
}
