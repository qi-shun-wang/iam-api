import Vapor

final class OpenIDController: RouteCollection {
    private let openIDRepository: OpenIDRepository
    
    init(openIDRepository: OpenIDRepository) {
        self.openIDRepository = openIDRepository
    }
    
    func boot(routes: RoutesBuilder) throws {
        
    }
}
