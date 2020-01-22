import FluentPostgreSQL

final class PSQLGroupPolicyRepository: GroupPolicyRepository {
    typealias DB = DatabaseConnectionPool<ConfiguredDatabase<PostgreSQLDatabase>>
    
    let db: DB

    init(_ db: DB) {
        self.db = db
    }
    
}
