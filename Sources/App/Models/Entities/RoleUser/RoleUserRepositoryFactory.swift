import Vapor

struct RoleUserRepositoryFactory {
    var make: ((Request) -> RoleUserRepository)?
    
    mutating func use(_ make: @escaping ((Request) -> RoleUserRepository)) {
        self.make = make
    }
}

extension Application {
    private struct RoleUserRepositoryKey: StorageKey {
        typealias Value = RoleUserRepositoryFactory
    }

    var roleUsers: RoleUserRepositoryFactory {
        get {
            self.storage[RoleUserRepositoryKey.self] ?? .init()
        }
        set {
            self.storage[RoleUserRepositoryKey.self] = newValue
        }
    }
}

extension Request {
    var roleUserRepository: RoleUserRepository {
        application.roleUsers.make!(self)
    }
}
