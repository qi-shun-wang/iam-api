import Vapor

final class RoleUserController: RouteCollection {
    private let roleUserRepository: RoleUserRepository
    
    init(roleUserRepository: RoleUserRepository) {
        self.roleUserRepository = roleUserRepository
    }
    
    func boot(router: Router) throws {
        
    }
}
