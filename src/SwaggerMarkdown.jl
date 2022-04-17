module SwaggerMarkdown

import JSONSchema
import YAML
import JSON

const ROOT = dirname(dirname(@__FILE__))

include("OpenAPI.jl")

export OpenAPI, build, @swagger, InvalidSwaggerSpecificationException

const DOCS = []

macro swagger(doc)
    m = @__MODULE__
    return esc(quote push!($m.DOCS, $doc) end)
end

function build(spec::AbstractDict{<:AbstractString,<:Any})::Dict{String, Any}
    spec_copy = spec
    if !haskey(spec_copy, "paths")
        spec_copy = deepcopy(spec)
        docs_string = join(DOCS)
        spec_copy["paths"] = YAML.load(docs_string)
    end
    validate_spec(spec_copy)
    return spec_copy
end

function build(openApi::OpenAPI)::Dict{String, Any}
    spec_dict = openApiToDict(openApi)
    if isempty(openApi.paths)
        docs_string = join(DOCS)
        spec_dict["paths"] = YAML.load(docs_string)
    end
    validate_spec(spec_dict)
    return spec_dict
end

function build(file::String)
    if endswith(file, ".json")
        return build(JSON.parsefile(file))
    end
    if endswith(file, ".yml") || endswith(file, ".yaml")
        return build(YAML.load_file(file, dicttype=Dict{String, Any}))
    end

    throw(ErrorException("Only support json or yaml file."))
end

end