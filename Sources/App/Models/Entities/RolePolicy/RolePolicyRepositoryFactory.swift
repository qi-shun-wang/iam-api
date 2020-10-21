import Vapor

struct RolePolicyRepositoryFactory {
    var make: ((Request) -> RolePolicyRepository)?
    
    mutating func use(_ make: @escaping ((Request) -> RolePolicyRepository)) {
        self.make = make
    }
}

extension Application {
    private struct RolePolicyRepositoryKey: StorageKey {
        typealias Value = RolePolicyRepositoryFactory
    }

    var rolePolicies: RolePolicyRepositoryFactory {
        get {
            self.storage[RolePolicyRepositoryKey.self] ?? .init()
        }
        set {
            self.storage[RolePolicyRepositoryKey.self] = newValue
        }
    }
}

extension Request {
    var rolePolicyRepository: RolePolicyRepository {
        application.rolePolicies.make!(self)
    }
}
