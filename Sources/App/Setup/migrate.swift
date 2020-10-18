import Vapor

/// Register your model's migrations here.
public func migrate(_ app: Application) {
    // Schema
    app.migrations.add(UserMigration(), to: .mongo)
    app.migrations.add(RoleMigration(), to: .mongo)
    app.migrations.add(PolicyMigration(), to: .mongo)
    app.migrations.add(GroupMigration(), to: .mongo)

    app.migrations.add(GroupPolicyMigration(), to: .mongo)
    app.migrations.add(RoleUserMigration(), to: .mongo)
    app.migrations.add(RolePolicyMigration(), to: .mongo)

    app.migrations.add(DefaultRolesMigration(), to: .mongo)
    app.migrations.add(DefaultPoliciesMigration(), to: .mongo)
    app.migrations.add(RootUserMigration(), to: .mongo)
    app.migrations.add(RootRolePolicyMigration(), to: .mongo)
    //    config.add(model: RolePolicy.self, database: .psql)
    //    config.add(migration: RootUserMigration.self, database: .psql)
    //    config.add(migration: RootPolicyMigration.self, database: .psql)
    //    config.add(migration: DefaultRolesMigration.self, database: .psql)
    //    config.add(migration: RootRolePolicyMigration.self, database: .psql)
    //    config.add(migration: RootUserRoleMigration.self, database: .psql)
    
}
