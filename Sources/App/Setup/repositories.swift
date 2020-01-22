import Vapor

public func setupRepositories(services: inout Services, config: inout Config) throws {
    services.register { (container) -> (PSQLPolicyRepository) in
        return try PSQLPolicyRepository(container.connectionPool(to: .psql))
    }
    services.register { (container) -> (PSQLGroupRepository) in
        return try PSQLGroupRepository(container.connectionPool(to: .psql))
    }
    services.register { (container) -> (PSQLGroupPolicyRepository) in
        return try PSQLGroupPolicyRepository(container.connectionPool(to: .psql))
    }
    services.register { (container) -> (PSQLGroupUserRepository) in
        return try PSQLGroupUserRepository(container.connectionPool(to: .psql))
    }
    services.register { (container) -> (PSQLOpenIDRepository) in
        return try PSQLOpenIDRepository(container.connectionPool(to: .psql))
    }
    services.register { (container) -> (PSQLRoleRepository) in
        return try PSQLRoleRepository(container.connectionPool(to: .psql))
    }
    services.register { (container) -> (PSQLRolePolicyRepository) in
        return try PSQLRolePolicyRepository(container.connectionPool(to: .psql))
    }
    services.register { (container) -> (PSQLRoleUserRepository) in
        return try PSQLRoleUserRepository(container.connectionPool(to: .psql))
    }
    services.register { (container) -> (PSQLUserRepository) in
        return try PSQLUserRepository(container.connectionPool(to: .psql))
    }
    preferDatabaseRepositories(config: &config)
}

private func preferDatabaseRepositories(config: inout Config) {
    config.prefer(PSQLPolicyRepository.self, for: PolicyRepository.self)
    config.prefer(PSQLGroupRepository.self, for: GroupRepository.self)
    config.prefer(PSQLGroupPolicyRepository.self, for: GroupPolicyRepository.self)
    config.prefer(PSQLGroupUserRepository.self, for: GroupUserRepository.self)
    config.prefer(PSQLOpenIDRepository.self, for: OpenIDRepository.self)
    config.prefer(RoleRepository.self, for: RoleRepository.self)
    config.prefer(PSQLRolePolicyRepository.self, for: RolePolicyRepository.self)
    config.prefer(PSQLRoleUserRepository.self, for: RoleUserRepository.self)
    config.prefer(PSQLUserRepository.self, for: UserRepository.self)
}
