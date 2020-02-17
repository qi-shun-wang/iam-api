// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "fd-iam-api",
    products: [
        .library(name: "IAM", targets: ["IAM"]),
        .library(name: "fd-iam-api", targets: ["App"]),
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.3.1"),
        // 🐘 Swift ORM (queries, models, relations, etc) built on PostgreSQL.
        .package(url: "https://github.com/vapor/fluent-postgresql.git", from: "1.0.0"),
        // 👤 Authentication and Authorization layer for Fluent.
        .package(url: "https://github.com/vapor/auth.git", from: "2.0.4"),
        // ✅ Extensible data validation library (name, email, etc)
        .package(url: "https://github.com/vapor/validation.git", from: "2.1.1"),
        // 🔑 Hashing (BCrypt, SHA2, HMAC), encryption (AES), public-key (RSA), and random data generation.
        .package(url: "https://github.com/vapor/crypto.git", from: "3.3.3"),
        // ⚙️ A collection of Swift extensions for wide range of Vapor data types and classes.
        .package(url: "https://github.com/vapor-community/vapor-ext.git", from: "0.3.4"),
    ],
    targets: [
        .target(name: "IAM", dependencies: ["Vapor"]),
        .target(name: "App", dependencies: [
            "Vapor"
            , "VaporExt"
            , "FluentPostgreSQL"
            , "Validation"
            , "Authentication"
            , "Crypto"
            , "IAM"
        ]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)

