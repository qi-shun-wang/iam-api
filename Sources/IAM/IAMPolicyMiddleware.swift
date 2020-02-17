import Vapor

public final class IAMPolicyMiddleware<P>: Middleware where P: IAMPolicyAllowable {
    
    public func respond(to request: Request, chainingTo next: Responder) throws -> EventLoopFuture<Response> {
        let config = try request.make(IAMConfig.self)
        let hostname = config.hostname
        let port = config.port
        let isInException = config.exceptionPaths.contains(request.http.url.path)
        
        guard !isInException else {
            return try next.respond(to: request)
        }
        
        let url = hostname + ":\(port)" + "/v1/identity/check"
        let httpReq = HTTPRequest(method: .GET,
                                  url: url,
                                  headers: request.http.headers)
        let req = Request(http: httpReq, using: request)
        
        return try request.client()
            .send(req)
            .flatMap { res in
                switch res.http.status {
                case .ok:
                    return try next.respond(to: request)
                default:
                    throw Abort(.unauthorized)
                }
        }
    }
}

public protocol IAMPolicyAllowable {}

extension IAMPolicyAllowable {
    public static func IAMAuthPolicyMiddleware(allowed policies: [String]) -> IAMPolicyMiddleware<Self> {
        return IAMPolicyMiddleware()
    }
}
