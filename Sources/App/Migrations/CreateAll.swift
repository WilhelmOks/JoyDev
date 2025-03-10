import Fluent

struct CreateAll: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("rants")
            .id()
            .field("rantId", .int64, .required)
            .field("text", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("rants").delete()
    }
}
