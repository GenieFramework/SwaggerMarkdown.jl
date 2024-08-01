using SwaggerMarkdown
using Test
using Aqua

const GET = "get"
const PUT = "put"
const POST = "post"

const ROOT = dirname(dirname(@__FILE__))
const TEST_ROOT = dirname(@__FILE__)
const SPECS_PATH = joinpath(TEST_ROOT, "specs")

@testset "Aqua" begin
  Aqua.test_all(SwaggerMarkdown)
end

include("file_build_tests.jl")
include("macro_build_tests.jl")