import Vapor

final class PolicyController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        //        let allowedPolicy = Application.IAMAuthPolicyMiddleware(allowed: [IAMPolicyIdentifier.root])
        let policies = routes.grouped("policies")//.grouped(allowedPolicy)
        policies.post(use: create)
        policies.get(use: index)
        policies.get(":id", use: select)
        policies.put(":id", use: update)
        policies.delete(":id", use: delete)
    }
    
    func create( _ req: Request) throws -> EventLoopFuture<Policy> {
        let form = try req.content.decode(CreatePolicyRequest.self)
        return req.policyRepository.save(policy: Policy(key: form.key, json: form.json))
        
    }
    
    func select( _ req: Request) throws -> EventLoopFuture<Policy> {
        guard let idString = req.parameters.get("id"),
              let id = Policy.IDValue(idString)
        else {throw Abort(HTTPResponseStatus.notFound)}
        let findPolicyFuture = req.policyRepository.find(id: id)
            .flatMapThrowing { (result) -> Policy in
                if let policy = result {
                    return policy
                } else {
                    throw Abort(.notFound)
                }
            }
        return findPolicyFuture
    }
    
    func index( _ req: Request) throws -> EventLoopFuture<[Policy]> {
        return req.policyRepository.all()
    }
    
    func update( _ req: Request) throws -> EventLoopFuture<Policy> {
        let form = try req.content.decode(UpdatePolicyRequest.self)
        let findPolicyFuture = try select(req)
        let updatePolicyFuture = findPolicyFuture
            .flatMap { (policy) -> EventLoopFuture<Policy> in
                if let new = form.key {
                    policy.key = new
                }
                if let new = form.json {
                    policy.json = new
                }
                return req.policyRepository.save(policy: policy)
            }
        return updatePolicyFuture
    }
    
    func delete( _ req: Request) throws -> EventLoopFuture<Response> {
        let findPolicyFuture = try select(req)
        let deletePolicyFuture = findPolicyFuture
            .flatMap { (policy) -> EventLoopFuture<Response> in
                return req.policyRepository.delete(policy: policy)
                    .transform(to: Response(status: .ok))
            }
        return deletePolicyFuture
    }
}
