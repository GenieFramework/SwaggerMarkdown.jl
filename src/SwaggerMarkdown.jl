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

function build(spec::Dict{String, Any})::Dict{String, Any}
    docs_string = join(DOCS)
    spec["paths"] = YAML.load(docs_string)
    validate_spec(spec)
    return spec
end

function build(spec::OpenAPI)::Dict{String, Any}
    docs_string = join(DOCS)
    docs_dict = YAML.load(docs_string)
    if isempty(spec.paths)
        spec.paths = docs_dict
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
    validate_spec(spec)
    return spec
end

function build(file::String)
    if endswith(file, ".json")
        return build(JSON.parsefile(file))
    end
    if endswith(file, ".yml")
        return build(YAML.load_file(file, dicttype=Dict{String, Any}))
    end
end

end