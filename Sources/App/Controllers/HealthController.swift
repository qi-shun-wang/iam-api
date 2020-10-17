import Vapor
import FluentMongoDriver
import Fluent

final class HealthController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let health = routes.grouped("health")
        
        health.get("db", use: check)
        
    }
    
    func check(_ req: Request) throws -> EventLoopFuture<Response> {
        return req.db.withConnection { (db) -> EventLoopFuture<Response> in
            return req.eventLoop.future(Response(status: .ok))
        }
    }
}
