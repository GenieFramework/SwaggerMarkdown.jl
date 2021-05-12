function parse_spec()
    paths = Dict{String, Any}()
    for filename in readdir(TMP)
        ext = split(filename, ".")[end]
        if (ext == "yml")
            for (path, val) in YAML.load_file(joinpath(TMP, filename), dicttype=Dict{String,Any})
                if !haskey(paths, path)
                    paths[path] = Dict{String, Any}()
                end
                for (method, v) in val
                    paths[path][method] = v
                end
            end
        end
    end
    # clean up
    rm(TMP, force=true, recursive=true)
    return paths
end

function merge_spec(spec::Union{OpenAPI, Dict{String, Any}}, paths)
    # load basic information
    if spec isa OpenAPI
        openApi = spec
        spec = Dict{String, Any}()
        spec["swagger"] = openApi.version
        spec["info"] = openApi.info
        for (key, val) in openApi.meta_data
            spec[key] = val
        end
    end

    # load paths
    if !haskey(spec, "paths")
        spec["paths"] = Dict{String, Array}()
    end
    spec["paths"] = paths
    return spec
end