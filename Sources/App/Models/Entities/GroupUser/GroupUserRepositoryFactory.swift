
import Vapor

struct GroupUserRepositoryFactory {
    var make: ((Request) -> GroupUserRepository)?
    
    mutating func use(_ make: @escaping ((Request) -> GroupUserRepository)) {
        self.make = make
    }
}

extension Application {
    private struct GroupUserRepositoryKey: StorageKey {
        typealias Value = GroupUserRepositoryFactory
    }

    var groupUsers: GroupUserRepositoryFactory {
        get {
            self.storage[GroupUserRepositoryKey.self] ?? .init()
        }
        set {
            self.storage[GroupUserRepositoryKey.self] = newValue
        }
    }
}

extension Request {
    var groupUserRepository: GroupUserRepository {
        application.groupUsers.make!(self)
    }
}
