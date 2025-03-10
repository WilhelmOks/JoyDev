import NIOSSL
import Fluent
import FluentPostgresDriver
import FluentSQLiteDriver
import Vapor

public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    try await configureDB(app)
    
    try routes(app)
}

private func configureDB(_ app: Application) async throws {
    enum Kind {
        case postgres
        case sqlite
        case sqliteInMemory
    }
    
    let kind: Kind = { .sqlite }()
    
    switch kind {
    case .postgres:
        app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
            hostname: Environment.get("DATABASE_HOST") ?? "localhost",
            port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
            username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
            password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
            database: Environment.get("DATABASE_NAME") ?? "vapor_database",
            tls: .prefer(try .init(configuration: .clientDefault)))
        ), as: .psql)
    case .sqlite:
        app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
    case .sqliteInMemory:
        app.databases.use(.sqlite(.memory), as: .sqlite)
    }
    
    app.migrations.add(CreateTodo())
    app.migrations.add(CreateAll())
    
    if kind != .postgres {
        try await app.autoMigrate()
    }
}
