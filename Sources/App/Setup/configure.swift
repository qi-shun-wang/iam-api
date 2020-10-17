import Vapor

/// Called before your application initializes.
public func configure(_ app: Application) throws {
    // Load .env file
//    Environment.dotenv()
    
    /// Register providers first
//    try services.register(FluentPostgreSQLProvider())
    /// Register a service for 'AuthenticationCache'
//    try services.register(AuthenticationProvider())
    /// Register server config
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
    
    
    
    /// Register Content Config
//        var contentConfig = ContentConfig.default()
//        try content(config: &contentConfig)
//        services.register(contentConfig)
    
    /// Register Commands
    //    var commandsConfig = CommandConfig.default()
    //    commands(config: &commandsConfig)
    //    services.register(commandsConfig)
    
    // MARK: Custom Session
    try setupCacheSessions(app)
    
    
    /// Register AWS Service
    //    try setupAWS(services: &services)
    //
    //    /// Register COS Service
    //    try setupCOS(services: &services)
    //
    //    /// Register SMS Service
    //    try setupSMS(services: &services)
    //
    //    /// Register FCM Service
    //    try setupFCM(services: &services)
    //
    //    /// Register Jobs
    //    try jobs(&services)
    
    /// Register Websocket Logger
    //    setupWebsocket(&config, &services)
    
}
