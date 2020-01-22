import FluentPostgreSQL

final class PSQLUserRepository: UserRepository {
    typealias DB = DatabaseConnectionPool<ConfiguredDatabase<PostgreSQLDatabase>>
    
    let db: DB

    init(_ db: DB) {
        self.db = db
    }
    
}
