function cleanup()
    tmp = SwaggerMarkdown.TMP
    rm(tmp, force=true, recursive=true)
end