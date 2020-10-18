import Vapor

/// Called before your application initializes.
public func configure(_ app: Application) throws {
    // Load .env file
//    Environment.dotenv()
 
    let port = Int(Environment.get(AppEnvironment.WEB_API_PORT.value) ?? "8080") ?? 8080
    app.http.server.configuration.port = port
    
    /// Register routes to the router
    try routes(app)
    /// Register middlewares
    try middlewares(app)
    /// Register databases.
    try databases(app)
    /// Register migrations
    migrate(app)
    
    /// Register Repositories
    try setupRepositories(app)
 
    // MARK: Custom Session
    try setupCacheSessions(app)
    
     
}
