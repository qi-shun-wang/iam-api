// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "fd-iam-api",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        .executable(name: "Run", targets: ["Run"]),
        .library(name: "App", targets: ["App"]),
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.32.0"),
        // 🐘 Swift ORM (queries, models, relations, etc) built on PostgreSQL.
        .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0"),
        
        .package(path: "../fluent-mongo-driver"),
//        .package(url: "https://github.com/vapor/fluent-mongo-driver.git", from: "1.0.0"),
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.1.0"),
        //        .package(url: "https://github.com/vapor/fluent-postgresql.git", from: "1.0.0"),
        //        // 👤 Authentication and Authorization layer for Fluent.
        //        .package(url: "https://github.com/vapor/auth.git", from: "2.0.4"),
        //        // ✅ Extensible data validation library (name, email, etc)
        //        .package(url: "https://github.com/vapor/validation.git", from: "2.1.1"),
        //        // 🔑 Hashing (BCrypt, SHA2, HMAC), encryption (AES), public-key (RSA), and random data generation.
        //        .package(url: "https://github.com/vapor/crypto.git", from: "3.3.3"),
        //        // ⚙️ A collection of Swift extensions for wide range of Vapor data types and classes.
        //        .package(url: "https://github.com/vapor-community/vapor-ext.git", from: "0.3.4"),
        //        //IAM Client for Identity and access management service base on Vapor Web Framework.
        //                .package(url: "https://github.com/qi-shun-wang/IAM-Service.git", from: "1.1.0"),
    ],
    targets: [
        .target(name: "App", dependencies: [
            .product(name: "Fluent", package: "fluent"),
            .product(name: "Vapor", package: "vapor"),
            .product(name: "FluentMongoDriver", package: "fluent-mongo-driver"),
            .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver")
            //            , "VaporExt"
            //            , "FluentPostgreSQL"
            //            , "Validation"
            //            , "Authentication"
            //            , "Crypto"
            //            , "IAM"
        ]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)

