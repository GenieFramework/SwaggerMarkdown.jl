module SwaggerMarkdown

import JSONSchema
import YAML
import JSON
import RelocatableFolders

const ROOT = dirname(dirname(@__FILE__))

include("Utils.jl")
include("OpenAPI.jl")

export OpenAPI, build, InvalidSwaggerSpecificationException
export @swagger, @swagger_str
export @swagger_schemas, @swagger_schemas_str
export @swagger_parameters, @swagger_parameters_str
export @swagger_requestBodies, @swagger_requestBodies_str
export @swagger_responses, @swagger_responses_str
export @swagger_headers, @swagger_headers_str
export @swagger_examples, @swagger_examples_str
export @swagger_links, @swagger_links_str
export @swagger_callbacks, @swagger_callbacks_str

const DOCS = []

# Components
const SCHEMAS = []
const PARAMETERS = []
const REQUESTBODIES = []
const RESPONSES = []
const HEADERS = []
const EXAMPLES = []
const LINKS = []
const CALLBACKS = []

### PATHS
macro swagger_str(doc)
    swagger(doc)
end

macro swagger(doc)
    swagger(doc)
end

function swagger(doc)
    m = @__MODULE__
    return esc(quote push!($m.DOCS, $doc) end)
end

### SCHEMAS
macro swagger_schemas_str(doc)
    swagger_schemas(doc)
end

macro swagger_schemas(doc)
    swagger_schemas(doc)
end

function swagger_schemas(doc)
    m = @__MODULE__
    return esc(quote push!($m.SCHEMAS, $doc) end)
end

### PARAMETERS
macro swagger_parameters_str(doc)
    swagger_parameters(doc)
end

macro swagger_parameters(doc)
    swagger_parameters(doc)
end

function swagger_parameters(doc)
    m = @__MODULE__
    return esc(quote push!($m.PARAMETERS, $doc) end)
end

### REQUESTBODIES
macro swagger_requestBodies_str(doc)
    swagger_requestBodies(doc)
end

macro swagger_requestBodies(doc)
    swagger_requestBodies(doc)
end

function swagger_requestBodies(doc)
    m = @__MODULE__
    return esc(quote push!($m.REQUESTBODIES, $doc) end)
end

### RESPONSES
macro swagger_responses_str(doc)
    swagger_responses(doc)
end

macro swagger_responses(doc)
    swagger_responses(doc)
end

function swagger_responses(doc)
    m = @__MODULE__
    return esc(quote push!($m.RESPONSES, $doc) end)
end

### HEADERS
macro swagger_headers_str(doc)
    swagger_headers(doc)
end

macro swagger_headers(doc)
    swagger_headers(doc)
end

function swagger_headers(doc)
    m = @__MODULE__
    return esc(quote push!($m.HEADERS, $doc) end)
end

### EXAMPLES
macro swagger_examples_str(doc)
    swagger_examples(doc)
end

macro swagger_examples(doc)
    swagger_examples(doc)
end

function swagger_examples(doc)
    m = @__MODULE__
    return esc(quote push!($m.EXAMPLES, $doc) end)
end

### LINKS
macro swagger_links_str(doc)
    swagger_links(doc)
end

macro swagger_links(doc)
    swagger_links(doc)
end

function swagger_links(doc)
    m = @__MODULE__
    return esc(quote push!($m.LINKS, $doc) end)
end

### CALLBACKS
macro swagger_callbacks_str(doc)
    swagger_callbacks(doc)
end

macro swagger_callbacks(doc)
    swagger_callbacks(doc)
end

function swagger_callbacks(doc)
    m = @__MODULE__
    return esc(quote push!($m.CALLBACKS, $doc) end)
end

function fill_components!(spec)
    tmp  = Dict{String, Any}()
    if !isempty(SCHEMAS)
        component_string = join(SCHEMAS)
        tmp["schemas"] = YAML.load(component_string)
    end

    if !isempty(PARAMETERS)
        component_string = join(PARAMETERS)
        tmp["parameters"] = YAML.load(component_string)
    end
    if !isempty(REQUESTBODIES)
        component_string = join(REQUESTBODIES)
        tmp["requestBodies"] = YAML.load(component_string)
    end
    if !isempty(RESPONSES)
        component_string = join(RESPONSES)
        tmp["responses"] = YAML.load(component_string)
    end
    if !isempty(HEADERS)
        component_string = join(HEADERS)
        tmp["headers"] = YAML.load(component_string)
    end
    if !isempty(EXAMPLES)
        component_string = join(EXAMPLES)
        tmp["examples"] = YAML.load(component_string)
    end
    if !isempty(LINKS)
        component_string = join(LINKS)
        tmp["links"] = YAML.load(component_string)
    end
    if !isempty(CALLBACKS)
        component_string = join(CALLBACKS)
        tmp["callbacks"] = YAML.load(component_string)
    end

    if !haskey(spec, "components")
        if !isempty(tmp)
            spec["components"] = tmp
        end
    else
        if !isempty(tmp)
            spec["components"] = merge_retaining(spec["components"], tmp)
        end
    end
end

function build(spec::AbstractDict{<:AbstractString,<:Any})::Dict{String, Any}
    spec_copy = spec
    if !haskey(spec_copy, "paths")
        spec_copy = deepcopy(spec)
        docs_string = join(DOCS)
        spec_copy["paths"] = YAML.load(docs_string)
    end
    fill_components!(spec_copy)
    validate_spec(spec_copy)
    return spec_copy
end

function build(openApi::OpenAPI)::Dict{String, Any}
    spec_dict = openApiToDict(openApi)
    if isempty(openApi.paths)
        docs_string = join(DOCS)
        spec_dict["paths"] = YAML.load(docs_string)
    end
    fill_components!(spec_dict)
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