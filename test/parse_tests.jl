include("parse_setup.jl")

@testset "Parse markdown for routes correctly" begin
    paths = SwaggerMarkdown.parse_spec()
    cleanup()

    @testset "'/' route should have GET, PUT and POST" begin
        ROOT = "/"
        @test haskey(paths, ROOT)
        r = paths[ROOT]
        @test haskey(r, GET)
        @test haskey(r, PUT)
        @test haskey(r, POST)

        for i in [GET, POST, PUT]
            @assert haskey(r[i], "description")
            @test r[i]["description"] == "Testing swagger markdown root $(i)!"
            @assert haskey(r[i], "responses")
            @assert haskey(r[i]["responses"], "200")
            @assert haskey(r[i]["responses"]["200"], "description")
            @test r[i]["responses"]["200"]["description"] == "Returns a mysterious string $(i)."
        end
    end

    @testset "'/test' route should have POST" begin
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
end

