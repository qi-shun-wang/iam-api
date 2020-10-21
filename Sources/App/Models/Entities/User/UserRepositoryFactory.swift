import Vapor

struct UserRepositoryFactory {
    var make: ((Request) -> UserRepository)?
    
    mutating func use(_ make: @escaping ((Request) -> UserRepository)) {
        self.make = make
    }
}

extension Application {
    private struct UserRepositoryKey: StorageKey {
        typealias Value = UserRepositoryFactory
    }

    var users: UserRepositoryFactory {
        get {
            self.storage[UserRepositoryKey.self] ?? .init()
        }
        set {
            self.storage[UserRepositoryKey.self] = newValue
        }
    }
}

extension Request {
    var userRepository: UserRepository {
        application.users.make!(self)
    }
}
