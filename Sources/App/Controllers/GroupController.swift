import Vapor

final class GroupController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        //        let allowedPolicy = Application.IAMAuthPolicyMiddleware(allowed: [IAMPolicyIdentifier.root])
        let groups = routes.grouped("groups")//.grouped(allowedPolicy)
        groups.post(use: create)
        groups.get(use: index)
        groups.get(":id", use: select)
        groups.put(":id", use: update)
        groups.delete(":id", use: delete)
    }
    
    func create( _ req: Request) throws -> EventLoopFuture<Group> {
        let form = try req.content.decode(CreateGroupRequest.self)
        
        return req.groupRepository.save(group: Group(name: form.name))
    }
    
    func select( _ req: Request) throws -> EventLoopFuture<Group> {
        guard let idString = req.parameters.get("id"),
              let id = Group.IDValue(idString)
        else {throw Abort(.notFound)}
        
        let findGroupFuture = req.groupRepository.find(id: id)
            .flatMapThrowing { (result) -> Group in
                if let group = result {
                    return group
                } else {
                    throw Abort(.notFound)
                }
            }
        
        return findGroupFuture
    }
    
    func index( _ req: Request) throws -> EventLoopFuture<[Group]> {
        return req.groupRepository.all()
    }
    
    func update( _ req: Request) throws -> EventLoopFuture<Group> {
        let form = try req.content.decode(UpdateGroupRequest.self)
        
        let findGroupFuture = try select(req)
        
        let updateGroupFuture = findGroupFuture
            .flatMap { (group) -> EventLoopFuture<Group> in
                if let new = form.name {
                    group.name = new
                }
                return req.groupRepository.save(group: group)
            }
        
        return updateGroupFuture
    }
    
    func delete( _ req: Request) throws -> EventLoopFuture<Response> {
        let findGroupFuture = try select(req)
        
        let deleteGroupFuture = findGroupFuture
            .flatMap { (group) -> EventLoopFuture<Response> in
                return req.groupRepository.delete(group: group)
                    .transform(to: Response(status: .ok))
            }
        
        return deleteGroupFuture
    }
    
}
