import Vapor

/// Register your application's middlewares here.
public func middlewares(config: inout MiddlewareConfig) throws {
    // CORS
    let corsConfig = CORSMiddleware.Configuration(
        allowedOrigin: .originBased,
        allowedMethods: [.GET, .POST, .PUT, .OPTIONS, .DELETE, .PATCH],
        allowedHeaders: [.accept,
                         .authorization,
                         .contentType,
                         .origin,
                         .xRequestedWith,
                         .accessControlAllowCredentials,
                         .accessControlAllowOrigin,
                         .accessControlAllowHeaders,
                         .accessControlAllowMethods,
                         .accessControlExpose,
                         .accessControlMaxAge,
                         .accessControlRequestMethod,
                         .accessControlRequestHeaders
        ],
        allowCredentials: true
    )
    
    let corsMiddleware = CORSMiddleware(configuration: corsConfig)
    config.use(corsMiddleware)
    config.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    config.use(SessionsMiddleware.self)
//    config.use(FileMiddleware.self) // Serves files from `Public/` directory
    
    // Other Middlewares...
}
