import Vapor

public func setupCacheSessions(_ app: Application) throws {
    
//    services.register(KeyedCache.self) { container in
//        try container.keyedCache(for: .psql)
//    }
//     
//    let cookie_domain = Environment.get(AppEnvironment.COOKIE_DOMAIN.value) ?? "localhost"
//    let cookie_secure = Environment.get(AppEnvironment.COOKIE_SECURE.value) ?? "false"
//    guard let is_cookie_secure = cookie_secure.bool else {
//        throw VaporError.init(identifier: AppEnvironment.COOKIE_SECURE.value, reason: "env COOKIE_SECURE not set")
//    }
//    
//    let sessionsConfig = SessionsConfig(cookieName: "fds") { value in
//        return  HTTPCookieValue(
//            string: value,
//            expires: Date(
//                timeIntervalSinceNow: 60 * 60 * 24 * 1 // one day //not working for session cache
//            ),
//            maxAge: nil,
//            domain: cookie_domain,
//            path: "/",
//            isSecure: is_cookie_secure,
//            isHTTPOnly: false,
//            sameSite: nil
//        )
//    }
//    
//    services.register(sessionsConfig)
}
