import Fluent
import Vapor
import VaporToOpenAPI

func routes(_ app: Application) throws {
    app.get { req async in
        "JoyDev Server"
    }

    app.get("hello") { req async -> String in
        "Hello, JoyDev!"
    }

    try app.register(collection: TodoController())
    
    app.post("rant") { req async throws -> Rant.CodingData in
        let entity = try req.content.decode(Rant.CodingData.self).decoded
        try await entity.save(on: req.db)
        return entity.encoded
    }
    
    app.get("rant-feed") { req async throws -> [Rant.CodingData] in
        try await Rant.query(on: req.db).all().map { $0.encoded }
    }
    
    // generate OpenAPI documentation
    app.get("openapi", "openapi.json") { req in
        req.application.routes.openAPI(
            info: InfoObject(
                title: "JoyDev Server",
                //description: "Example API description",
                version: "0.1.0"
            )
        )
    }
    .excludeFromOpenAPI()
}
