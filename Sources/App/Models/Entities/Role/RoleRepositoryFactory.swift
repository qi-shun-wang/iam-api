
import Vapor

struct RoleRepositoryFactory {
    var make: ((Request) -> RoleRepository)?
    
    mutating func use(_ make: @escaping ((Request) -> RoleRepository)) {
        self.make = make
    }
}

extension Application {
    private struct RoleRepositoryKey: StorageKey {
        typealias Value = RoleRepositoryFactory
    }

    var roles: RoleRepositoryFactory {
        get {
            self.storage[RoleRepositoryKey.self] ?? .init()
        }
        set {
            self.storage[RoleRepositoryKey.self] = newValue
        }
    }
}

extension Request {
    var roleRepository: RoleRepository {
        application.roles.make!(self)
    }
}
