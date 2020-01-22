import Vapor

final class RolePolicyController: RouteCollection {
    private let rolePolicyRepository: RolePolicyRepository
    
    init(rolePolicyRepository: RolePolicyRepository) {
        self.rolePolicyRepository = rolePolicyRepository
    }
    
    func boot(router: Router) throws {
        
    }
}
