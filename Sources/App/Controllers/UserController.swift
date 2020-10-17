import Vapor
import Crypto

final class UserController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        //        let allowedPolicy = Application.IAMAuthPolicyMiddleware(allowed: [IAMPolicyIdentifier.root])
        let users = routes.grouped("users")//.grouped(allowedPolicy)
        users.post(use: create)
        users.get(use: index)
        users.get(":id", use: select)
        users.put(":id", use: update)
        users.delete(":id", use: delete)
    }
    
    func create( _ req: Request) throws -> EventLoopFuture<User> {
        let form = try req.content.decode(CreateUserRequest.self)
        
        let user = User(accountID: form.accountID,
                        password: form.password,
                        accessID: UUID().uuidString,
                        accessKey: UUID().uuidString)
        return req.userRepository.save(user: user)
    }
    
    func select( _ req: Request) throws -> EventLoopFuture<User> {
        guard let idString = req.parameters.get("id"),
              let id = User.IDValue(idString)
        else {throw Abort(.notFound)}
        
        let findUserFuture = req.userRepository.find(id: id)
            .flatMapThrowing { (result) -> User in
                if let user = result {
                    return user
                } else {
                    throw Abort(.notFound)
                }
            }
        return findUserFuture
    }
    
    func index( _ req: Request) throws -> EventLoopFuture<[User]> {
        return req.userRepository.all()
    }
    
    func update( _ req: Request) throws -> EventLoopFuture<User> {
        let form = try req.content.decode(UpdateUserRequest.self)
        let findUserFuture = try select(req)
        let updateUserFuture = findUserFuture
            .flatMap { (user) -> EventLoopFuture<User> in
                if let new = form.accountID {
                    user.accountID = new
                }
                if let new = form.password {
                    user.password = new
                }
                return req.userRepository.save(user: user)
            }
        return updateUserFuture
    }
    
    func delete( _ req: Request) throws -> EventLoopFuture<Response> {
        let findUserFuture = try select(req)
        let deleteUserFuture = findUserFuture
            .flatMap { (user) -> EventLoopFuture<Response> in
                return req.userRepository.delete(user: user)
                    .transform(to: Response(status: .ok))
            }
        
        return deleteUserFuture
        
    }
}
