import Vapor

final class PolicyController: RouteCollection {
    private let policyRepository: PolicyRepository
    
    init(policyRepository: PolicyRepository) {
        self.policyRepository = policyRepository
    }
    
    func boot(router: Router) throws {
     
    }
}
