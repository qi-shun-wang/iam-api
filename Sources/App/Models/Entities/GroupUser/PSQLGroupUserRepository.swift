import FluentPostgreSQL

final class PSQLGroupUserRepository: GroupUserRepository {
    typealias DB = DatabaseConnectionPool<ConfiguredDatabase<PostgreSQLDatabase>>
    
    let db: DB

    init(_ db: DB) {
        self.db = db
    }
    
}
