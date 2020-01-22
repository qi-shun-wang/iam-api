import FluentPostgreSQL
import VaporExt

/// Register your application's databases here.
public func databases(config: inout DatabasesConfig) throws {
    // Configure a PostgreSQL database
    let psqlConfig = PostgreSQLDatabaseConfig(hostname: Environment.get(AppEnvironment.PSQL_HOSTNAME.value)  ?? "localhost",
                                              port: Int(Environment.get(AppEnvironment.PSQL_PORT.value) ?? "5432")!,
                                              username: Environment.get(AppEnvironment.PSQL_USERNAME.value) ?? "vapor",
                                              database: Environment.get(AppEnvironment.PSQL_DATABASE_NAME.value) ?? "vapor",
                                              password: Environment.get(AppEnvironment.PSQL_PASSWORD.value) ?? "vapor",
                                              transport: PostgreSQLConnection.TransportConfig.cleartext)
    
    /// Register the databases
    let postgresDB = PostgreSQLDatabase(config: psqlConfig)
    config.add(database: postgresDB, as: .psql)
    
    if Environment.get(AppEnvironment.PSQL_LOGS.value, false) {
        config.enableLogging(on: .psql)
    }
    
}
