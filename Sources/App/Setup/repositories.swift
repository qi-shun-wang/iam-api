import Vapor

public func setupRepositories(_ app: Application) throws {
    app.users.use { (req) -> UserRepository in
        DatabaseUserRepository(db: req.db)
    }
    app.groups.use { req in
        DatabaseGroupRepository(db: req.db)
    }
    app.policies.use { req in
        DatabasePolicyRepository(db: req.db)
    }
    app.roles.use { req in
        DatabaseRoleRepository(db: req.db)
    }
    app.groupUsers.use { req in
        DatabaseGroupUserRepository(db: req.db)
    }
    app.groupPolicies.use { req in
        DatabaseGroupPolicyRepository(db: req.db)
    }
    app.roleUsers.use { req in
        DatabaseRoleUserRepository(db: req.db)
    }
    app.rolePolicies.use { req in
        DatabaseRolePolicyRepository(db: req.db)
    }
}
