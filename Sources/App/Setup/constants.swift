//MARK: Environment Constants
enum AppEnvironment: String {
    case PSQL_HOSTNAME
    case PSQL_PORT
    case PSQL_USERNAME
    case PSQL_DATABASE_NAME
    case PSQL_PASSWORD
    case PSQL_LOGS
    
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
