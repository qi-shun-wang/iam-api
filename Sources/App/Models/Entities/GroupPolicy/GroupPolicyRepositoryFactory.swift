import Vapor

struct GroupPolicyRepositoryFactory {
    var make: ((Request) -> GroupPolicyRepository)?
    
    mutating func use(_ make: @escaping ((Request) -> GroupPolicyRepository)) {
        self.make = make
    }
}

extension Application {
    private struct GroupPolicyRepositoryKey: StorageKey {
        typealias Value = GroupPolicyRepositoryFactory
    }

    var groupPolicies: GroupPolicyRepositoryFactory {
        get {
            self.storage[GroupPolicyRepositoryKey.self] ?? .init()
        }
        set {
            self.storage[GroupPolicyRepositoryKey.self] = newValue
        }
    }
}

extension Request {
    var groupPolicyRepository: GroupPolicyRepository {
        application.groupPolicies.make!(self)
    }
}
