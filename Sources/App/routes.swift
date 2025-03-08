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
