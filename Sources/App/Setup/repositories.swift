import Vapor

public func setupRepositories(_ app: Application) throws {
//    services.register(PolicyRepository.self) { (container) -> (PSQLPolicyRepository) in
//        return try PSQLPolicyRepository(container.connectionPool(to: .psql))
//    }
//    services.register(GroupRepository.self) { (container) -> (PSQLGroupRepository) in
//        return try PSQLGroupRepository(container.connectionPool(to: .psql))
//    }
//    services.register(GroupPolicyRepository.self) { (container) -> (PSQLGroupPolicyRepository) in
//        return try PSQLGroupPolicyRepository(container.connectionPool(to: .psql))
//    }
//    services.register(GroupUserRepository.self) { (container) -> (PSQLGroupUserRepository) in
//        return try PSQLGroupUserRepository(container.connectionPool(to: .psql))
//    }
//    services.register(OpenIDRepository.self) { (container) -> (PSQLOpenIDRepository) in
//        return try PSQLOpenIDRepository(container.connectionPool(to: .psql))
//    }
//    services.register(RoleRepository.self) { (container) -> (PSQLRoleRepository) in
//        return try PSQLRoleRepository(container.connectionPool(to: .psql))
//    }
//    services.register(RolePolicyRepository.self) { (container) -> (PSQLRolePolicyRepository) in
//        return try PSQLRolePolicyRepository(container.connectionPool(to: .psql))
//    }
//    services.register(RoleUserRepository.self) { (container) -> (PSQLRoleUserRepository) in
//        return try PSQLRoleUserRepository(container.connectionPool(to: .psql))
//    }
//    services.register(UserRepository.self) { (container) -> (PSQLUserRepository) in
//        return try PSQLUserRepository(container.connectionPool(to: .psql))
//    }
//    preferDatabaseRepositories(config: &config)
}
//
//private func preferDatabaseRepositories(config: inout Config) {
//    config.prefer(PSQLPolicyRepository.self, for: PolicyRepository.self)
//    config.prefer(PSQLGroupRepository.self, for: GroupRepository.self)
//    config.prefer(PSQLGroupPolicyRepository.self, for: GroupPolicyRepository.self)
//    config.prefer(PSQLGroupUserRepository.self, for: GroupUserRepository.self)
//    config.prefer(PSQLOpenIDRepository.self, for: OpenIDRepository.self)
//    config.prefer(RoleRepository.self, for: RoleRepository.self)
//    config.prefer(PSQLRolePolicyRepository.self, for: RolePolicyRepository.self)
//    config.prefer(PSQLRoleUserRepository.self, for: RoleUserRepository.self)
//    config.prefer(PSQLUserRepository.self, for: UserRepository.self)
//}
