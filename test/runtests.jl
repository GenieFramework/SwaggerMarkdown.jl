using SwaggerMarkdown
using Test

const GET = "get"
const PUT = "put"
const POST = "post"

const ROOT = dirname(dirname(@__FILE__))
const TEST_ROOT = dirname(@__FILE__)
const SPECS_PATH = joinpath(TEST_ROOT, "specs")

include("file_build_tests.jl")
include("macro_build_tests.jl")
include("macro_components_build_tests.jl")