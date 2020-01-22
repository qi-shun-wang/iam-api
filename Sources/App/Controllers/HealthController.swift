import Vapor

final class HealthController: RouteCollection {
    func boot(router: Router) throws {
        let health = router.grouped("health")
        
        health.get("db", use: check)
         
    }
    
    func check(_ req: Request) throws -> EventLoopFuture<HTTPResponse> {
        return req.databaseConnection(to: .psql).map { (c)  in
            if (c.isClosed){
                throw Abort(.serviceUnavailable)
            } else {
                return HTTPResponse(status: .ok)
            }
        }
    }
}
