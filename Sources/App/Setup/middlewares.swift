import Vapor
import IAM
/// Register your application's middlewares here.
public func middlewares(config: inout MiddlewareConfig, services: inout Services) throws {
    // CORS
    let allowedOrigin = Environment.get(AppEnvironment.CORS_ORIGINS.value, "http://localhost")
    let corsConfig = CORSMiddleware.Configuration(
        allowedOrigin: .custom(allowedOrigin),
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
    
    
    let iamHostname = Environment.get(AppEnvironment.IAM_HOSTNAME.value, "http://localhost")
    let iamPort = Environment.get(AppEnvironment.IAM_PORT.value, 80)
    let iamConfig = IAMConfig(hostname: iamHostname,
                              port: iamPort,
                              exceptionPaths: ["/v1/identity/check",
                                               "/v1/identity/token"])
    services.register(iamConfig)
    config.use(corsMiddleware)
    config.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    config.use(SessionsMiddleware.self)
    //    config.use(FileMiddleware.self) // Serves files from `Public/` directory
    
    // Other Middlewares...
}
