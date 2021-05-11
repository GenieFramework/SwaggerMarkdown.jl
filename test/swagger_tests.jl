const ROOT_GET = """
/:
  get:
    description: Testing swagger markdown!
    responses:
      '200':
        description: Returns a mysterious string.
"""

@testset "@swagger writes markdowns to files" begin
    tmp = SwaggerMarkdown.TMP
    @swagger """
    /:
      get:
        description: Testing swagger markdown!
        responses:
          '200':
            description: Returns a mysterious string.
    """

    @assert isdir(SwaggerMarkdown.TMP)
    content = ""
    for filename in readdir(tmp)
        ext = split(filename, ".")[end]
        if (ext == "yml")
            io = open(joinpath(tmp, filename), "r")
            content *= read(io, String)
            close(io)
        end
    end
    cleanup()

    @test ROOT_GET == content
    
end