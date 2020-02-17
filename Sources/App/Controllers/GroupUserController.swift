import Vapor

final class GroupUserController: RouteCollection {
    private let groupUserRepository: GroupUserRepository
    private let groupRepository: GroupRepository
    private let userRepository: UserRepository
    
    init(groupRepository: GroupRepository,
         userRepository: UserRepository,
         groupUserRepository: GroupUserRepository) {
        self.groupRepository = groupRepository
        self.userRepository = userRepository
        self.groupUserRepository = groupUserRepository
    }
    
    func boot(router: Router) throws {
        let allowedPolicy = User.IAMAuthPolicyMiddleware(allowed: [IAMPolicyIdentifier.root])
        let groups = router.grouped("groups").grouped(allowedPolicy)
        let users = router.grouped("users").grouped(allowedPolicy)
        users.get(User.ID.parameter, "groups", use: indexGroups)
        groups.get(Group.ID.parameter, "users", use: indexUsers)
        groups.delete(Group.ID.parameter, "users", User.ID.parameter, use: delete)
        groups.post(Group.ID.parameter, "users", User.ID.parameter, use: create)
    }
    
    func create(_ req: Request) throws -> Future<HTTPResponse> {
        let groupID = try req.parameters.next(Group.ID.self)
        let userID = try req.parameters.next(User.ID.self)
        return self.groupUserRepository.findPivot(groupID, userID).flatMap { result in
            if result == nil {
                return self.groupUserRepository
                    .create(GroupUser(groupID: groupID, userID: userID))
                    .transform(to: HTTPResponse(status: .ok))
            }
            return req.future(HTTPResponse(status: .ok))
        }
    }
    
    func delete(_ req: Request) throws -> Future<HTTPResponse> {
        let groupID = try req.parameters.next(Group.ID.self)
        let userID = try req.parameters.next(User.ID.self)
        return self.groupUserRepository.findPivot(groupID, userID).flatMap { result in
            if let pivot = result {
                return self.groupUserRepository
                    .delete(pivot)
                    .transform(to: HTTPResponse(status: .ok))
            }
            
            return req.future(HTTPResponse(status: .ok))
        }
    }
    
    func indexUsers(_ req: Request) throws -> Future<[User]> {
        let groupID = try req.parameters.next(Group.ID.self)
        return groupRepository.find(id: groupID).flatMap { (result) -> EventLoopFuture<[User]> in
            guard let group = result else {throw Abort(HTTPResponseStatus.notFound)}
            return self.groupUserRepository.findUsers(group)
        }
    }
    
    func indexGroups(_ req: Request) throws -> Future<[Group]> {
        let userID = try req.parameters.next(User.ID.self)
        return userRepository.find(id: userID).flatMap { (result) -> EventLoopFuture<[Group]> in
            guard let user = result else {throw Abort(HTTPResponseStatus.notFound)}
            return self.groupUserRepository.findGroups(user)
        }
    }
}
