function cleanup()
    tmp = SwaggerMarkdown.TMP
    if isdir(tmp)
        rm(tmp, recursive=true)
    end
end