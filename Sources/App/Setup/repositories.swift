import Vapor

public func setupRepositories(_ app: Application) throws {
    app.users.use { (req) -> UserRepository in
        MongoDBUserRepository(db: req.db)
    }
    app.groups.use { req in
        MongoDBGroupRepository(db: req.db)
    }
    app.policies.use { req in
        MongoDBPolicyRepository(db: req.db)
    }
    app.roles.use { req in
        MongoDBRoleRepository(db: req.db)
    }
    app.groupUsers.use { req in
        MongoDBGroupUserRepository(db: req.db)
    }
    app.groupPolicies.use { req in
        MongoDBGroupPolicyRepository(db: req.db)
    }
    app.roleUsers.use { req in
        MongoDBRoleUserRepository(db: req.db)
    }
    app.rolePolicies.use { req in
        MongoDBRolePolicyRepository(db: req.db)
    }
}
