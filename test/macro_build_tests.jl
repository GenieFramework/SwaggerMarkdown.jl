@testset "Build directly through Dict with @swagger_str" begin
    swagger"""
    /test_swagger_str:
        post:
            description: Testing swagger markdown test!
            responses:
                '200':
                    description: Returns a mysterious string test.
    """

    @swagger """
    /test_swagger:
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
        "swagger" => "2.0"
    ])
    spec = build(spec)
    @test haskey(spec, "paths")
    
    paths = spec["paths"];
    @test haskey(paths, "/test_swagger")
    @test haskey(paths, "/test_swagger_str")
end

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
        "swagger" => "2.0"
    ])
    spec = build(spec)
    @test haskey(spec, "paths")
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

    spec = build(openApi)

    @assert haskey(spec, "swagger")
    @assert haskey(spec, "paths")
    @assert haskey(spec, "info")

    @test openApi.version == "2.0"
    @test openApi.info["title"] == "Swagger Petstore"
    @test openApi.info["version"] == "1.0.5"

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