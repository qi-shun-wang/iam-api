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
    
    case USER_TOKEN_SECRET
    
    case WEB_API_PORT
    case WEB_API_PATH
    
    case VERIFY_WEB_URL
    
    case SMTP_HOSTNAME
    case SMTP_USERNAME
    case SMTP_PASSWORD
    
    case IAM_HOSTNAME
    case IAM_PORT
    
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
