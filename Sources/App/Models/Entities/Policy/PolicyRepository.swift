import Vapor

protocol PolicyRepository: Service {
    func find(id: Int) -> Future<Policy?>
    func all() -> Future<[Policy]>
    func find(email: String) -> Future<Policy?>
    func findCount(email: String) -> Future<Int>
    func save(user: Policy) -> Future<Policy>
}
