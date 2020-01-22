import FluentPostgreSQL

final class PSQLOpenIDRepository: OpenIDRepository {
    typealias DB = DatabaseConnectionPool<ConfiguredDatabase<PostgreSQLDatabase>>
    
    let db: DB

    init(_ db: DB) {
        self.db = db
    }
    
}
