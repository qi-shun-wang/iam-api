import Fluent

final class PSQLOpenIDRepository: OpenIDRepository {
    typealias DB = Database
    
    let db: DB

    init(_ db: DB) {
        self.db = db
    }
    
}
