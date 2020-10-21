import Vapor

/// Register your model's migrations here.
public func migrate(_ app: Application) {
    // Schema
    app.migrations.add(UserMigration(), to: .psql)
    app.migrations.add(RoleMigration(), to: .psql)
    app.migrations.add(PolicyMigration(), to: .psql)
    app.migrations.add(GroupMigration(), to: .psql)

    app.migrations.add(GroupPolicyMigration(), to: .psql)
    app.migrations.add(RoleUserMigration(), to: .psql)
    app.migrations.add(RolePolicyMigration(), to: .psql)

    app.migrations.add(DefaultRolesMigration(), to: .psql)
    app.migrations.add(DefaultPoliciesMigration(), to: .psql)
    app.migrations.add(RootUserMigration(), to: .psql)
    app.migrations.add(RootRolePolicyMigration(), to: .psql) 
    
}
