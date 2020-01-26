import Vapor
import Crypto
import Authentication
final class IdentityController: RouteCollection {
    
    private let roleRepository: RoleRepository
    private let userRepository: UserRepository
    private let groupUserRepository: GroupUserRepository
    private let roleUserRepository: RoleUserRepository
    private let rolePolicyRepository: RolePolicyRepository
    private let groupPolicyRepository: GroupPolicyRepository
    
    init(roleRepository: RoleRepository,
         userRepository: UserRepository,
         roleUserRepository: RoleUserRepository,
         rolePolicyRepository: RolePolicyRepository,
         groupPolicyRepository: GroupPolicyRepository,
         groupUserRepository: GroupUserRepository) {
        
        self.roleRepository = roleRepository
        self.userRepository = userRepository
        self.roleUserRepository = roleUserRepository
        self.rolePolicyRepository = rolePolicyRepository
        self.groupPolicyRepository = groupPolicyRepository
        self.groupUserRepository = groupUserRepository
    }
    
    func boot(router: Router) throws {
        let token = User.tokenAuthMiddleware()
        let password = User.basicAuthMiddleware(using: PlaintextVerifier())
        let identity = router.grouped("identity")
        identity.post(use: create)
        identity.grouped(token).get("check", use: check)
        identity.grouped(password).get("token", use: auth)
    }
    
    func check(_ req: Request) throws -> Future<CheckIdentityResponse> {
        let user = try req.requireAuthenticated(User.self)
        return self.roleUserRepository.findRoles(user).flatMap { roles in
            return self.groupUserRepository.findGroups(user).flatMap { groups  in
                return self.rolePolicyRepository.findPolicies(in: roles).flatMap { (rPolicies) in
                    return self.groupPolicyRepository.findPolicies(in: groups).map { (gPolicies) in
                        var p:[String] = []
                        p.append(contentsOf: rPolicies.map{$0.key})
                        p.append(contentsOf: gPolicies.map{$0.key})
                        return try CheckIdentityResponse(id: user.requireID(),
                                                         groups: groups.map{$0.name},
                                                         roles: roles.map {$0.type},
                                                         policies: p)
                    }
                }
            }
        }
    }
    
    func auth(_ req: Request) throws -> Future<User.TokenForm> {
        let user = try req.requireAuthenticated(User.self)
        user.accessKey = UUID().uuidString
        return self.userRepository.save(user: user).map { user in
            return User.TokenForm(token: user.accessKey)
        }
    }
    
    func create(_ req: Request) throws -> Future<HTTPResponse>{
        return try req.content.decode(CreateIdentityRequest.self)
            .flatMap { (form) -> EventLoopFuture<HTTPResponse> in
                let roleFuture = self.roleRepository.find(type: form.role)
                    .map { result -> Role in
                        guard let role = result else {
                            throw Abort(.badRequest)
                        }
                        return role
                }
                let userFuture = self.userRepository.find(accountID: form.accountID)
                    .flatMap { (result) -> Future<User> in
                        if result != nil { throw Abort(.found)}
                        let new = User(accountID: form.accountID,
                                       password: form.password,
                                       accessID: UUID().uuidString,
                                       accessKey: UUID().uuidString)
                        return self.userRepository.save(user: new)
                }
                return roleFuture.flatMap { role in
                    return userFuture.flatMap { user in
                        let roleID = try role.requireID()
                        let userID = try user.requireID()
                        let pivotFuture = self.roleUserRepository.findPivot(roleID, userID)
                            .flatMap { result -> EventLoopFuture<RoleUser> in
                                if result != nil {
                                    throw Abort(.internalServerError,reason: "Exist Role User relation.")
                                } else {
                                    let new = try RoleUser(role, user)
                                    return self.roleUserRepository.create(new)
                                }
                        }
                        return pivotFuture.transform(to: HTTPResponse(status: .ok))
                    }
                }
                
        }
    }
}
