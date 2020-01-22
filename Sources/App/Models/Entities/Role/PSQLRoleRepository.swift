import FluentPostgreSQL

final class PSQLRoleRepository: RoleRepository {
    typealias DB = DatabaseConnectionPool<ConfiguredDatabase<PostgreSQLDatabase>>
    
    let db: DB

    init(_ db: DB) {
        self.db = db
    }
    
}
