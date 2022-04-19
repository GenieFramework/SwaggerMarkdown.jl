@testset "Build from valid json/yml files" begin
    valid_specs = ["spec1_valid_v3.yml", "spec1_valid_v2.yml", "spec1_valid_v3.json", "spec1_valid_v2.json"]

    for filename in valid_specs
        spec = build(joinpath(SPECS_PATH, filename))
        @test haskey(spec, "info")
        @test haskey(spec, "paths")
        @test (haskey(spec, "swagger") || haskey(spec, "openapi"))
    end
end

@testset "Build from invalid json/yml files" begin
    invalid_specs = ["spec1_invalid_v3.yml", "spec1_invalid_v2.yml", "spec1_invalid_v3.json", "spec1_invalid_v2.json"]

    for filename in invalid_specs
        @test_throws SwaggerMarkdown.InvalidSwaggerSpecificationException build(joinpath(SPECS_PATH, filename))
    end
end