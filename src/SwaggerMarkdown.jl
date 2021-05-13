module SwaggerMarkdown

import JSONSchema
import YAML
import JSON
import UUIDs

include("OpenAPI.jl")
include("Utils.jl")

export OpenAPI, build, @swagger, validate_spec

const TMP = "tmp"

macro swagger(doc)
    if !isdir(TMP)
        mkdir(TMP)
    end
    return :( io = open(joinpath(SwaggerMarkdown.TMP, "$(string(UUIDs.uuid4())).yml"), "w"); write(io, $doc); close(io) )
end


function build(spec::Union{OpenAPI, Dict{String, Any}}; doc_parser::Function=parse_spec)
    paths = doc_parser()
    spec = merge_spec(spec, paths)
    validate_spec(spec)
    return spec
end


function build(file::String; doc_parser::Function=parse_spec)
    spec = JSON.parsefile(file)
    return build(spec, doc_parser=doc_parser)
end


end # module
