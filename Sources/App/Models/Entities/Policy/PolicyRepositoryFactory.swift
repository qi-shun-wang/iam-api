import Vapor

struct PolicyRepositoryFactory {
    var make: ((Request) -> PolicyRepository)?
    
    mutating func use(_ make: @escaping ((Request) -> PolicyRepository)) {
        self.make = make
    }
}

extension Application {
    private struct PolicyRepositoryKey: StorageKey {
        typealias Value = PolicyRepositoryFactory
    }

    var policies: PolicyRepositoryFactory {
        get {
            self.storage[PolicyRepositoryKey.self] ?? .init()
        }
        set {
            self.storage[PolicyRepositoryKey.self] = newValue
        }
    }
}

extension Request {
    var policyRepository: PolicyRepository {
        application.policies.make!(self)
    }
}
