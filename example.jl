# using Genie, Genie.Router
# using Genie.Renderer, Genie.Renderer.Html, Genie.Renderer.Json

using JSON
using SwaggerMarkdown

@swagger """
/doge:
  get:
    description: doge
    responses:
      '200':
        description: Returns a doge.
"""

@swagger """
/to:
  put:
    description: to
    responses:
      '200':
        description: Returns a doge.
"""

@swagger """
/the:
  post:
    description: the
    responses:
      '200':
        description: Returns a doge.
"""

@swagger """
/moon:
  get:
    description: moon
    responses:
      '200':
        description: Returns a moon.
"""


function run_example()
    info = Dict{String, Any}()
    info["title"] = "Doge to the moon"
    info["version"] = "1.0.5"
    openApi = OpenAPI("2.0", info)

    spec = build(openApi)
    println(JSON.json(spec))
end

run_example()
