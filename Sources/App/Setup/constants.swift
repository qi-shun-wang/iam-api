//MARK: Environment Constants
enum AppEnvironment: String {
    
    case MONGO_DB_CONNECTION_URI
    case COOKIE_SECURE
    case COOKIE_DOMAIN
    
    case WEB_API_PORT
   
    case IAM_HOSTNAME
    case IAM_PORT
    case IAM_ENABLE
    
    case CORS_ORIGINS
    
    var value: String {
        get {
            return self.rawValue
        }
    }
}

public struct IAMPolicyIdentifier {
    private init(){}
    static let root = "ROOT"
}
