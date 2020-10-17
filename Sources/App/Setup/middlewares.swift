import Vapor
//import IAM
/// Register your application's middlewares here.
public func middlewares(_ app: Application) throws {
    // CORS
    let allowedOrigin = Environment.get(AppEnvironment.CORS_ORIGINS.value) ?? "http://localhost"
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
    
    
    let iamHostname = Environment.get(AppEnvironment.IAM_HOSTNAME.value)
    let iamPort = Environment.get(AppEnvironment.IAM_PORT.value)
    let iamEnable = Environment.get(AppEnvironment.IAM_ENABLE.value)
    
//    let iamConfig = IAMConfig(hostname: iamHostname,
//                              port: iamPort,
//                              exceptionPaths: ["/v1/identity/check",
//                                               "/v1/identity/token"],
//                              isEnable: iamEnable)
//    services.register(iamConfig)
    app.middleware.use(corsMiddleware)
    app.middleware.use(ErrorMiddleware.default(environment: app.environment))
//    app.middleware.use(SessionsMiddleware.init(session: <#T##SessionDriver#>, configuration: <#T##SessionsConfiguration#>))
    app.middleware.use(FileMiddleware.init(publicDirectory: "Public/"))
    // Other Middlewares...
}
