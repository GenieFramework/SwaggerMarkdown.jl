mutable struct OpenAPI
    version::String
    info::Dict{String, Any}
    meta_data::Dict{String, Any}

    function OpenAPI(version::String, info::Dict{String, Any}; meta_data::Dict{String, Any}=Dict{String, Any}())
        this = new()
        this.version = version
        this.info= info
        this.meta_data = meta_data
        return this
    end
end