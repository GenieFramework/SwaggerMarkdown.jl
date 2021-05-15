using SwaggerMarkdown
using Test

const GET = "get"
const PUT = "put"
const POST = "post"

const ROOT = dirname(dirname(@__FILE__))
const TEST_ROOT = dirname(@__FILE__)
const SPECS_PATH = joinpath(TEST_ROOT, "specs")

include("utils.jl")
include("swagger_tests.jl")
include("parse_tests.jl")
include("build_tests.jl")
include("validation_tests.jl")