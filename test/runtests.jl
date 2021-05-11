using SwaggerMarkdown
using Test

const GET = "get"
const PUT = "put"
const POST = "post"

include("utils.jl")
include("swagger_tests.jl")
include("parse_tests.jl")
include("build_tests.jl")