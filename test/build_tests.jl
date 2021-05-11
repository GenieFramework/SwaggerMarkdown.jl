include("build_setup.jl")

@testset "Build OpenAPI correctly" begin
    info = Dict{String, Any}()
    info["title"] = "Swagger Petstore"
    info["version"] = "1.0.5"
    openApi = OpenAPI("2.0", info)

    @test openApi.version == "2.0"
    @test openApi.info["title"] == "Swagger Petstore"
    @test openApi.info["version"] == "1.0.5"
end

@testset "Build final spec correctly" begin
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