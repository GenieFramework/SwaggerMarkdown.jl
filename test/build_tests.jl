@testset "Build directly through Dict" begin
    @swagger """
    /test:
        post:
            description: Testing swagger markdown test!
            responses:
                '200':
                    description: Returns a mysterious string test.
    """

    spec = Dict{String, Any}([
        "info" => Dict{String, Any}([
            "version" => "2.0",
            "title" => "Swagger Petstore"
        ]),
        "swagger" => "2.0",
        "paths" => paths
    ])
    spec = build(spec)
    @test haskey(spec, "paths")
end

@testset "Build from json/yml files" begin
    valid_specs = ["spec1_valid_v3.yml", "spec1_valid_v2.yml", "spec1_valid_v3.json", "spec1_valid_v2.json"]
    for filename in valid_specs
        spec = build(joinpath(SPECS_PATH, filename))
        @test haskey(spec, "info")
        @test haskey(spec, "paths")
        @test (haskey(spec, "swagger") || haskey(spec, "openapi"))
    end
end

@testset "Build OpenAPI correctly" begin
    @swagger """
    /test:
        post:
            description: Testing swagger markdown test!
            responses:
                '200':
                    description: Returns a mysterious string test.
    """
    info = Dict{String, Any}()
    info["title"] = "Swagger Petstore"
    info["version"] = "1.0.5"
    openApi = OpenAPI("2.0", info)

    @test openApi.version == "2.0"
    @test openApi.info["title"] == "Swagger Petstore"
    @test openApi.info["version"] == "1.0.5"
end

@testset "Build final spec correctly" begin
    @swagger """
    /test:
        post:
            description: Testing swagger markdown test!
            responses:
                '200':
                    description: Returns a mysterious string test.
    """
    info = Dict{String, Any}()
    info["title"] = "Swagger Petstore"
    info["version"] = "1.0.5"
    openApi = OpenAPI("2.0", info)

    spec = build(openApi)
    cleanup()

    @assert haskey(spec, "swagger")
    @assert haskey(spec, "paths")
    @assert haskey(spec, "info")

    @test spec["swagger"] == "2.0"
    @test spec["info"]["title"] == "Swagger Petstore"
    @test spec["info"]["version"] == "1.0.5"

    paths = spec["paths"]

    TEST = "/test"
    @test haskey(paths, TEST)
    r = paths[TEST]
    @test haskey(r, POST)
    @assert haskey(r[POST], "description")
    @test r[POST]["description"] == "Testing swagger markdown test!"
    @assert haskey(r[POST], "responses")
    @assert haskey(r[POST]["responses"], "200")
    @assert haskey(r[POST]["responses"]["200"], "description")
    @test r[POST]["responses"]["200"]["description"] == "Returns a mysterious string test."
end