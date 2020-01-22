import FluentPostgreSQL
import Authentication
/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Load .env file
//    Environment.dotenv()
    
    /// Register providers first
    try services.register(FluentPostgreSQLProvider())
    /// Register a service for 'AuthenticationCache'
    try services.register(AuthenticationProvider())
    /// Register server config
    var serverConfig = NIOServerConfig.default()
    serverConfig.port = Environment.get(AppEnvironment.WEB_API_PORT.value, 8080)
    services.register(serverConfig)
    
    /// Register routes to the router
    services.register { (container) -> (EngineRouter) in
        let router = EngineRouter.default()
        try routes(router, container)
        return router
    }
    
    /// Register middlewares
    var middlewaresConfig = MiddlewareConfig()
    try middlewares(config: &middlewaresConfig)
    services.register(middlewaresConfig)
    
    /// Register databases.
    var databasesConfig = DatabasesConfig()
    try databases(config: &databasesConfig)
    services.register(databasesConfig)
    
    /// Register migrations
    var migrationsConfig = MigrationConfig()
    migrate(config: &migrationsConfig)
    services.register(migrationsConfig)
    
    /// Register Repositories
    try setupRepositories(services: &services, config: &config)
    
    
    
    /// Register Content Config
    //    var contentConfig = ContentConfig.default()
    //    try content(config: &contentConfig)
    //    services.register(contentConfig)
    
    /// Register Commands
    //    var commandsConfig = CommandConfig.default()
    //    commands(config: &commandsConfig)
    //    services.register(commandsConfig)
    
    // MARK: Custom Session
    try setupCacheSessions(services: &services)
    config.prefer(DatabaseKeyedCache<ConfiguredDatabase<PostgreSQLDatabase>>.self, for: KeyedCache.self)
    
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
