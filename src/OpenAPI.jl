const SCHEMA_DIR = joinpath(ROOT, "schema")
const VERSIONS = Dict([
    "2.0" => "v2",
    "3.0" => "v3",
])

mutable struct OpenAPI
    version::String
    info::Dict{String, Any}
    paths::Dict{String, Any}
    optional_fields::Dict{String, Any}

    function OpenAPI(version::String, info::Dict{String, Any}; optional_fields::Dict{String, Any}=Dict{String, Any}())
        this = new()
        this.version = version
        this.info= info
        this.optional_fields = optional_fields
        return this
    end
end
struct InvalidSwaggerSpecificationException <:Exception
    issue::JSONSchema.SingleIssue
end

function Base.showerror(io::IO, e::InvalidSwaggerSpecificationException)
    issue = e.issue
    println(io, """\n
    Validation failed:
    path:         $(isempty(issue.path) ? "top-level" : issue.path)
    instance:     $(issue.x)
    schema key:   $(issue.reason)
    schema value: $(issue.val)""")
end

function validate_spec(spec::Dict{String, Any})
    @assert haskey(spec, "swagger") "Field 'swagger' is missing"
    version = spec["swagger"]
    @assert haskey(VERSIONS, version) "Version $(version) is not supported"

    openapi_schema = JSONSchema.Schema(JSON.parsefile(joinpath(SCHEMA_DIR , "$(VERSIONS[version]).json")))
    
    issue = JSONSchema.validate(spec, openapi_schema)
    if issue !== nothing
        throw(InvalidSwaggerSpecificationException(issue))
    end
end

function validate_spec(file::String)
    validate_spec(JSON.parsefile(file))
end

