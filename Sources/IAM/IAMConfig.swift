public class IAMConfig {
    let hostname: String
    let port: Int
    let exceptionPaths: [String]
    
    public init(hostname: String, port: Int = 8080, exceptionPaths: [String] = []) {
        self.hostname = hostname
        self.port = port
        self.exceptionPaths = exceptionPaths
    }
}
