import Vapor
import FluentPostgresDriver
/// Register your application's databases here.
public func databases(_ app: Application) throws {
    // Configure a PostgreSQL database
    let dbURI =  Environment.get(AppEnvironment.MONGO_DB_CONNECTION_URI.value) ?? "mongodb://localhost:27017/test"
//    try app.databases.use(.mongo(connectionString: dbURI), as: .mongo)
    try app.databases.use(.postgres(url: "postgresql://postgres:password@localhost:5432"), as: .psql)
    
}
 
