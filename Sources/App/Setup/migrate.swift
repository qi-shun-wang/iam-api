import FluentPostgreSQL

/// Register your model's migrations here.
public func migrate(config: inout MigrationConfig) {
   
    config.add(model: Group.self, database: .psql)
    config.add(model: User.self, database: .psql)
    config.add(model: Role.self, database: .psql)
    config.add(model: Policy.self, database: .psql)
    config.add(model: OpenID.self, database: .psql)
    
    config.add(model: GroupPolicy.self, database: .psql)
    config.add(model: GroupUser.self, database: .psql)
    config.add(model: RoleUser.self, database: .psql)
    config.add(model: RolePolicy.self, database: .psql)
    config.prepareCache(for: .psql)
}
