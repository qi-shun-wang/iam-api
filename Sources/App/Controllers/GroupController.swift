import Vapor

final class GroupController: RouteCollection {
    private let groupRepository: GroupRepository
    
    init(groupRepository: GroupRepository) {
        self.groupRepository = groupRepository
    }
    
    func boot(router: Router) throws {
        let groups = router.grouped("groups")
        groups.post(use: create)
        groups.get(use: index)
        groups.get(Group.ID.parameter, use: select)
        groups.put(Group.ID.parameter, use: update)
        groups.delete(Group.ID.parameter, use: delete)
    }
    
    func create( _ req: Request) throws -> Future<Group> {
        return try req.content.decode(CreateGroupRequest.self).flatMap { form  in
            return self.groupRepository.save(group: Group(name: form.name))
        }
    }
    
    func select( _ req: Request) throws -> Future<Group> {
        let id = try req.parameters.next(Group.ID.self)
        return self.groupRepository.find(id: id).map { result in
            guard let group = result else { throw Abort(HTTPResponseStatus.notFound) }
            return group
        }
    }
    
    func index( _ req: Request) throws -> Future<[Group]> {
        return self.groupRepository.all()
    }
    
    func update( _ req: Request) throws -> Future<Group> {
        let groupID = try req.parameters.next(Group.ID.self)
        return try req.content.decode(UpdateGroupRequest.self).flatMap { form  in
            return self.groupRepository.find(id: groupID).flatMap { result in
                if let group = result {
                    if let new = form.name {
                        group.name = new
                    }
                    return self.groupRepository.save(group: group)
                } else {
                    throw Abort(.notFound)
                }
            }
        }
    }
    
    func delete( _ req: Request) throws -> Future<HTTPResponse> {
        let groupID = try req.parameters.next(Group.ID.self)
        return self.groupRepository.find(id: groupID).flatMap { result in
            if let group = result {
                return self.groupRepository.delete(group: group).transform(to: HTTPResponse(status: .ok))
            } else {
                throw Abort(.notFound)
            }
        }
    }
    
}
