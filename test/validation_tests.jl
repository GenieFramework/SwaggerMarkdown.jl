using YAML

const info = Dict{String, Any}([
    "title"   => "Doge to the moon"
    "version" => "1.0.5"
])

@swagger """
/doge:
  get:
    description: doge
    responses:
      '200':
        description: Returns a doge.
"""

@swagger """
/bad:
  get:
    description: doge
    responses:
      '200':
        description: Returns a doge.
        bad: I'm causing trouble!!
"""

const all_paths = SwaggerMarkdown.parse_spec()

function get_paths(ps)
    res = Dict{String, Any}()
    for p in ps
        res[p] = all_paths[p]
    end
    return res
end

paths = get_paths(["/doge"])
invalid_paths = get_paths(["/bad"])

function get_optional_fields(version)
    if version == "2.0"
        return Dict{String, Any}(["host" => "localhost", "basePath" => "/doge"])
    end
    if startswith(version, "3.0")
        return Dict{String, Any}(["servers" => [Dict(["url" => "localhost"])]])
    end
end

function get_invalid_optional_fields(version)
    optional_fields = get_optional_fields(version)
    optional_fields["bad"] = "bad"
    return optional_fields
end

function valid_basic(openApi, version)
    spec = build(openApi)
    if version == "2.0"
        @test spec["swagger"] == version
    elseif version == "3.0"
        @test spec["openapi"] == "3.0.0"
    else
        @test spec["openapi"] == version
    end
    @test spec["info"] == info
    @test spec["paths"] == paths
end

function throws(openApi, _)
    @test_throws SwaggerMarkdown.InvalidSwaggerSpecificationException build(openApi)
end

versions = ["2.0", "3.0", "3.0.1"]
cases = Dict([
    "Required Fields excluding 'paths' tests" => Dict([
        "Fields missing" => Dict([
            "info" => Dict{String, Any}(["title" => "Doge to the moon"]),
            "paths" => paths,
            "test" => throws
        ]),
        "Invalid fields" => Dict([
            "info" => Dict{String, Any}(["title" => "Doge to the moon"]),
            "paths" => paths,
            "test" => throws
        ]),
        "All valid" => Dict([
            "info" => info,
            "paths" => paths,
            "test" => valid_basic
        ])
    ]),
    "Optional Fields tests" => Dict([
        "Invalid fields" => Dict([
            "info" => info,
            "paths" => paths,
            "optional_fields" => get_invalid_optional_fields,
            "test" => throws
        ]),
        "All valid" => Dict([
            "info" => info,
            "paths" => paths,
            "optional_fields" => get_optional_fields,
            "test" => valid_basic
        ])
    ]),
    "paths' field tests" => Dict([
        "Invalid fields" => Dict([
            "info" => info,
            "paths" => invalid_paths,
            "test" => throws
        ])
    ])
])

for version in versions
    for (case, val) in cases
        @testset "Version $(version) - $(case)" begin
            for (subcase_name, subcase) in val
                @testset "$(subcase_name)" begin
                    openApi = OpenAPI(version, subcase["info"])
                    openApi.paths = subcase["paths"]
                    if haskey(subcase, "optional_fields")
                        openApi.optional_fields = subcase["optional_fields"](version)
                    end
                    subcase["test"](openApi, version)
                end
            end
        end
    end
end

const valid_specs = ["spec1_valid_v3.yml", "spec1_valid_v2.yml", "spec1_valid_v3.json", "spec1_valid_v2.json"]
const invalid_specs = ["spec1_invalid_v3.yml", "spec1_invalid_v2.yml", "spec1_invalid_v3.json", "spec1_invalid_v2.json"]

# More complex tests
@testset "Validate more complex specifications" begin
    for spec in valid_specs
        @test SwaggerMarkdown.validate_spec(joinpath(SPECS_PATH, spec)) === nothing
    end
    for spec in invalid_specs
        @test_throws SwaggerMarkdown.InvalidSwaggerSpecificationException SwaggerMarkdown.validate_spec(joinpath(SPECS_PATH, spec))
    end
end