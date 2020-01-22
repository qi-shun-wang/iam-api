import Vapor

final class GroupUserController: RouteCollection {
    private let groupUserRepository: GroupUserRepository
    
    init(groupUserRepository: GroupUserRepository) {
        self.groupUserRepository = groupUserRepository
    }
    
    func boot(router: Router) throws {
        
    }
}
