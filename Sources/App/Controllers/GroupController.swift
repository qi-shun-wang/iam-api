import Vapor

final class GroupController: RouteCollection {
    private let groupRepository: GroupRepository
    
    init(groupRepository: GroupRepository) {
        self.groupRepository = groupRepository
    }
    
    func boot(router: Router) throws {
        
    }
}
