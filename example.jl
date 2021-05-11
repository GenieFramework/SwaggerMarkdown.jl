# using Genie, Genie.Router
# using Genie.Renderer, Genie.Renderer.Html, Genie.Renderer.Json

using JSON
using SwaggerMarkdown

@swagger """
/:
  get:
    description: Welcome to swagger-jsdoc!
    responses:
      '200':
        description: Returns a mysterious string.
"""

@swagger """
/:
  put:
    description: Welcome to swagger-jsdoc!
    responses:
      '200':
        description: Returns a mysterious string.
"""

@swagger """
/fff:
  post:
    description: Welcome to swagger-jsdoc!
    responses:
      '200':
        description: Returns a mysterious string.
"""


function test()
    info = Dict{String, Any}()
    info["title"] = "Swagger Petstore"
    info["version"] = "1.0.5"
    openApi = OpenAPI("2.0", info)

    spec = build(openApi)
    println(JSON.json(spec))
end

test()
