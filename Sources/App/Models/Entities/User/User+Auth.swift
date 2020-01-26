import Authentication

extension User: Token {
    
    static var userIDKey: WritableKeyPath<User, User.ID> {
        return \.id!
    }
    
    typealias UserType = User
    
    typealias UserIDType = User.ID
    
    static var tokenKey: WritableKeyPath<User, String> {
        return \.accessKey
    }
    
}

extension User: TokenAuthenticatable {
    typealias TokenType = User
}

extension User: PasswordAuthenticatable {
    static var usernameKey: WritableKeyPath<User, String> {
        return \.accountID
    }
    static var passwordKey: WritableKeyPath<User, String> {
        return \.password
    }
}
