module SwaggerMarkdown

import JSONSchema
import YAML
import JSON
import UUIDs

const ROOT = dirname(dirname(@__FILE__))

include("OpenAPI.jl")
include("Utils.jl")

export OpenAPI, build, @swagger, validate_spec

const TMP = joinpath(ROOT, "tmp")

macro swagger(doc)
    if !isdir(TMP)
        mkdir(TMP)
    end
    return :( io = open(joinpath(SwaggerMarkdown.TMP, "$(string(UUIDs.uuid4())).yml"), "w"); write(io, $doc); close(io) )
end

"""
    build(spec::Union{OpenAPI, Dict{String, Any}})::Dict{String, Any}

Build a `Dict{String, Any}` as OpenAPI definitions.

# Arguments
Required:
- `spec::Union{OpenAPI, Dict{String, Any}}` : An `OpenAPI` or a `Dict{String, Any}}` with some pre-defined specs.
"""
function build(spec::Union{OpenAPI, Dict{String, Any}}; doc_parser::Function=parse_spec)::Dict{String, Any}
    if spec isa OpenAPI 
        if isempty(spec.paths)
            spec.paths = doc_parser()
        end
        openApi = spec
        spec = Dict{String, Any}()
        version_name = openApi.version == "2.0" ? "swagger" : "openapi"
        spec[version_name] = openApi.version
        spec["info"] = openApi.info
        spec["paths"] = openApi.paths
        for (key, val) in openApi.optional_fields
            spec[key] = val
        end
    else # spec is Dict{String, Any} type
        if !haskey(spec, "paths")
            spec["paths"] = doc_parser()
        end
    end
    validate_spec(spec)
    return spec
end

"""
    build(file::String)::Dict{String, Any}

Build a `Dict{String, Any}()` as OpenAPI definitions from a `json` or `yml` file.

# Arguments
Required:
- `file::String` : A `json` or `yml` file used to build the OpenAPI definitions.
"""
function build(file::String; doc_parser::Function=parse_spec)::Dict{String, Any}
    if endswith(file, ".json")
        return build(JSON.parsefile(file), doc_parser=doc_parser)
    end
    if endswith(file, ".yml")
        return build(YAML.load_file(file, dicttype=Dict{String, Any}), doc_parser=doc_parser)
    end
end


end # module
