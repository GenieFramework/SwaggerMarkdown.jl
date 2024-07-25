module SwaggerMarkdown

import JSONSchema
import YAML
import JSON
import RelocatableFolders

const ROOT = dirname(dirname(@__FILE__))

include("OpenAPI.jl")

export OpenAPI, build, InvalidSwaggerSpecificationException
export @swagger, @swagger_str
export @swagger_schemas_str, @swagger_schemas
export @swagger_pathitems_str, @swagger_pathitems
export @swagger_parameters_str, @swagger_parameters
export @swagger_requestBodies_str, @swagger_requestBodies
export @swagger_responses_str, @swagger_responses
export @swagger_headers_str, @swagger_headers
export @swagger_examples_str, @swagger_examples
export @swagger_links_str, @swagger_links
export @swagger_links_str, @swagger_links

const DOCS = []

# Components
const SCHEMAS = []
const PATHITEMS = []
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

### PATHITEMS
macro swagger_pathitems_str(doc)
    swagger_pathitems(doc)
end

macro swagger_pathitems(doc)
    swagger_pathitems(doc)
end

function swagger_pathitems(doc)
    m = @__MODULE__
    return esc(quote push!($m.PATHITEMS, $doc) end)
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
    if !haskey(spec, "components")
        spec["components"] = Dict{String, Any}()
    end
    
    if !isempty(SCHEMAS)
        component_string = join(SCHEMAS)
        spec["components"]["schemas"] = YAML.load(component_string)
    end

    if !isempty(PATHITEMS)
        component_string = join(PATHITEMS)
        spec["components"]["pathitems"] = YAML.load(component_string)
    end
    if !isempty(PARAMETERS)
        component_string = join(PARAMETERS)
        spec["components"]["parameters"] = YAML.load(component_string)
    end
    if !isempty(REQUESTBODIES)
        component_string = join(REQUESTBODIES)
        spec["components"]["requestbodies"] = YAML.load(component_string)
    end
    if !isempty(RESPONSES)
        component_string = join(RESPONSES)
        spec["components"]["responses"] = YAML.load(component_string)
    end
    if !isempty(HEADERS)
        component_string = join(HEADERS)
        spec["components"]["headers"] = YAML.load(component_string)
    end
    if !isempty(EXAMPLES)
        component_string = join(EXAMPLES)
        spec["components"]["examples"] = YAML.load(component_string)
    end
    if !isempty(LINKS)
        component_string = join(LINKS)
        spec["components"]["links"] = YAML.load(component_string)
    end
    if !isempty(CALLBACKS)
        component_string = join(CALLBACKS)
        spec["components"]["callbacks"] = YAML.load(component_string)
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