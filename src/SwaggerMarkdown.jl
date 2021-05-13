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


function build(spec::Union{OpenAPI, Dict{String, Any}}; doc_parser::Function=parse_spec)
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

function build(file::String; doc_parser::Function=parse_spec)
    spec = JSON.parsefile(file)
    return build(spec, doc_parser=doc_parser)
end


end # module
