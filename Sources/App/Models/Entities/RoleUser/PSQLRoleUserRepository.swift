import FluentPostgreSQL

final class PSQLRoleUserRepository: RoleUserRepository {
    typealias DB = DatabaseConnectionPool<ConfiguredDatabase<PostgreSQLDatabase>>
    
    let db: DB
    
    init(_ db: DB) {
        self.db = db
    }
    
}
