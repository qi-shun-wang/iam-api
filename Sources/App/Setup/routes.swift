import Vapor

public func routes(_ router: Router, _ container: Container) throws {
    let v1 = router.grouped("v1")
    
    let rolePolicyController = try RolePolicyController(roleRepository: container.make(),
                                                        policyRepository: container.make(),
                                                        rolePolicyRepository: container.make())
    
    let roleUserController = try RoleUserController(roleRepository: container.make(),
                                                    userRepository: container.make(),
                                                    roleUserRepository: container.make())
    
    let groupUserController = try GroupUserController(groupRepository: container.make(),
                                                      userRepository: container.make(),
                                                      groupUserRepository: container.make())
    let groupPolicyController = try GroupPolicyController(groupRepository: container.make(),
                                                          policyRepository: container.make(),
                                                          groupPolicyRepository: container.make())
    
    let identityController = try IdentityController(roleRepository: container.make(),
                                                    userRepository: container.make(),
                                                    roleUserRepository: container.make(),
                                                    rolePolicyRepository: container.make(),
                                                    groupPolicyRepository: container.make(),
                                                    groupUserRepository: container.make())
    
    try v1.register(collection: identityController)
    try v1.register(collection: UserController(userRepository: container.make()))
    try v1.register(collection: PolicyController(policyRepository: container.make()))
    try v1.register(collection: GroupController(groupRepository: container.make()))
    try v1.register(collection: RoleController(roleRepository: container.make()))
    
    try v1.register(collection: OpenIDController(openIDRepository: container.make()))
    
    try v1.register(collection: groupPolicyController)
    try v1.register(collection: groupUserController)
    try v1.register(collection: rolePolicyController)
    try v1.register(collection: roleUserController)
    try v1.register(collection: HealthController())
}
