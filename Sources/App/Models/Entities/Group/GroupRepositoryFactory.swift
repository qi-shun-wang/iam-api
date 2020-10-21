import Vapor

struct GroupRepositoryFactory {
    var make: ((Request) -> GroupRepository)?
    
    mutating func use(_ make: @escaping ((Request) -> GroupRepository)) {
        self.make = make
    }
}

extension Application {
    private struct GroupRepositoryKey: StorageKey {
        typealias Value = GroupRepositoryFactory
    }

    var groups: GroupRepositoryFactory {
        get {
            self.storage[GroupRepositoryKey.self] ?? .init()
        }
        set {
            self.storage[GroupRepositoryKey.self] = newValue
        }
    }
}

extension Request {
    var groupRepository: GroupRepository {
        application.groups.make!(self)
    }
}
