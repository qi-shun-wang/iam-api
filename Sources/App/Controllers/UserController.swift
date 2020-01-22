import Vapor

final class UserController: RouteCollection {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func boot(router: Router) throws {
        
    }
}
