import Vapor

final class PolicyController: RouteCollection {
    private let policyRepository: PolicyRepository
    
    init(policyRepository: PolicyRepository) {
        self.policyRepository = policyRepository
    }
    
    func boot(router: Router) throws {
        let policies = router.grouped("policies")
        policies.post(use: create)
        policies.get(use: index)
        policies.get(Policy.ID.parameter, use: select)
        policies.put(Policy.ID.parameter, use: update)
        policies.delete(Policy.ID.parameter, use: delete)
    }
    
    func create( _ req: Request) throws -> Future<Policy> {
        return try req.content.decode(CreatePolicyRequest.self).flatMap { form  in
            return self.policyRepository.save(policy: Policy(key: form.key, json: form.json))
        }
    }
    
    func select( _ req: Request) throws -> Future<Policy> {
        let id = try req.parameters.next(Policy.ID.self)
        return self.policyRepository.find(id: id).map { result in
            guard let policy = result else { throw Abort(HTTPResponseStatus.notFound) }
            return policy
        }
    }
    
    func index( _ req: Request) throws -> Future<[Policy]> {
        return self.policyRepository.all()
    }
    
    func update( _ req: Request) throws -> Future<Policy> {
        let policyID = try req.parameters.next(Policy.ID.self)
        return try req.content.decode(UpdatePolicyRequest.self).flatMap { form  in
            return self.policyRepository.find(id: policyID).flatMap { result in
                if let policy = result {
                    if let new = form.key {
                        policy.key = new
                    }
                    if let new = form.json {
                        policy.json = new
                    }
                    return self.policyRepository.save(policy: policy)
                } else {
                    throw Abort(.notFound)
                }
            }
        }
    }
    
    func delete( _ req: Request) throws -> Future<HTTPResponse> {
        let policyID = try req.parameters.next(Policy.ID.self)
        return self.policyRepository.find(id: policyID).flatMap { result in
            if let policy = result {
                return self.policyRepository.delete(policy: policy).transform(to: HTTPResponse(status: .ok))
            } else {
                throw Abort(.notFound)
            }
        }
    }
}
