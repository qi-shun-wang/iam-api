import Vapor

final class RoleController: RouteCollection {
    private let roleRepository: RoleRepository
    
    init(roleRepository: RoleRepository) {
        self.roleRepository = roleRepository
    }
    
    func boot(router: Router) throws {
        
    }
}
