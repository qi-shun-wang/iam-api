import Vapor
import Crypto
import IAM

final class UserController: RouteCollection {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func boot(router: Router) throws {
        let allowedPolicy = User.IAMAuthPolicyMiddleware(allowed: [IAMPolicyIdentifier.root])
        let users = router.grouped("users").grouped(allowedPolicy)
        users.post(use: create)
        users.get(use: index)
        users.get(User.ID.parameter, use: select)
        users.put(User.ID.parameter, use: update)
        users.delete(User.ID.parameter, use: delete)
    }
    
    func create( _ req: Request) throws -> Future<User> {
        return try req.content.decode(CreateUserRequest.self).flatMap { form  in
            let user = User(accountID: form.accountID,
                            password: form.password,
                            accessID: UUID().uuidString,
                            accessKey: UUID().uuidString)
            return self.userRepository.save(user: user)
        }
    }
    
    func select( _ req: Request) throws -> Future<User> {
        let id = try req.parameters.next(User.ID.self)
        return self.userRepository.find(id: id).map { result in
            guard let user = result else { throw Abort(HTTPResponseStatus.notFound) }
            return user
        }
    }
    
    func index( _ req: Request) throws -> Future<[User]> {
        return self.userRepository.all()
    }
    
    func update( _ req: Request) throws -> Future<User> {
        let userID = try req.parameters.next(User.ID.self)
        let userFuture = self.userRepository.find(id: userID)
            .map { (result) -> User in
                guard let user = result else { throw Abort(.notFound)}
                return user
        }
        return userFuture.flatMap { user in
            return try req.content.decode(UpdateUserRequest.self).flatMap { form  in
                if let new = form.accountID {
                    user.accountID = new
                }
                if let new = form.password {
                    user.password = new
                }
                return self.userRepository.save(user: user)
            }
        }
    }
    
    func delete( _ req: Request) throws -> Future<HTTPResponse> {
        let userID = try req.parameters.next(User.ID.self)
        let userFuture = self.userRepository.find(id: userID)
            .map { (result) -> User in
                guard let user = result else { throw Abort(.notFound)}
                return user
        }
        return userFuture.flatMap { user in
            return self.userRepository.delete(user: user).transform(to: HTTPResponse(status: .ok))
        }
        
    }
}
