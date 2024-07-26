@testset "Build components directly through Dict with @swagger_str" begin
    @swagger"""
    /test_swagger:
        post:
            description: Testing swagger markdown test!
            responses:
                '200':
                    description: Returns a mysterious string test.
    """
    
    # https://support.smartbear.com/swaggerhub/docs/en/domains/openapi-3-0-domain-example.html
    @swagger_schemas"""
    ErrorModel:
        type: object
        required:
            - code
            - message
        properties:
            code:
                type: integer
                format: int32
            message:
                type: string
    """

    @swagger_parameters"""
    offsetParam:
        name: offset
        in: query
        schema:
            type: integer
            minimum: 0
        description: The number of items to skip before returning the results
    limitParam:
        in: query
        name: limit
        schema:
            type: integer
            format: int32
            minimum: 1
            maximum: 100
            default: 20
        description: The number of items to return
    """

    @swagger_requestBodies"""
    NewItem:
        description: A JSON object containing item data
        required: true
        content:
            application/json:
                schema:
                    type: object
                examples:
                    tshirt:
                        \$ref: '#/components/examples/tshirt'
    """

    @swagger_responses"""
    GeneralError:
        description: An error occurred
        content:
            application/json:
                schema:
                    \$ref: '#/components/schemas/ErrorModel'
        headers:
            X-RateLimit-Limit:
                \$ref: '#/components/headers/X-RateLimit-Limit'
            X-RateLimit-Remaining:
                \$ref: '#/components/headers/X-RateLimit-Remaining'
    """

    @swagger_headers"""
    X-RateLimit-Limit:
        description: Request limit per hour
        schema:
            type: integer
        example: 100
    X-RateLimit-Remaining:
        description: Remaining requests for the hour
        schema:
            type: integer
        example: 94
    """

    @swagger_examples"""
    tshirt:
        summary: Sample T-shirt data
        value:
            # Example value starts here
            id: 17
            name: T-shirt
            description: 100% cotton shirt
            categories: [clothes]
    """

    # https://swagger.io/docs/specification/links/
    @swagger_links"""
    GetUserByUserId:   # <---- arbitrary name for the link
        operationId: getUser
        parameters:
            userId: '\$response.body#/id'
        description: >
            The `id` value returned in the response can be used as
            the `userId` parameter in `GET /users/{userId}`.
    """

    # https://swagger.io/docs/specification/callbacks/
    @swagger_callbacks"""
    myEvent:   # Event name
        '{\$request.body#/callbackUrl}':   # The callback URL,
                                        # Refers to the passed URL
            post:
                requestBody:   # Contents of the callback message
                    required: true
                    content:
                        application/json:
                            schema:
                                type: object
                                properties:
                                    message:
                                        type: string
                                        example: Some event happened
                                required:
                                    - message
                responses:   # Expected responses to the callback message
                    '200':
                        description: Your server returns this code if it accepts the callback
    """

    spec = Dict{String, Any}([
        "info" => Dict{String, Any}([
            "version" => "3.0",
            "title" => "API example"
        ]),
        "openapi" => "3.0"
    ])

    spec = build(spec)
    @test haskey(spec, "paths")

    paths = spec["paths"]
    @test haskey(paths, "/test_swagger")

    components = spec["components"]

    schemas = components["schemas"]
    @test haskey(schemas, "ErrorModel")

    parameters = components["parameters"]
    @test haskey(parameters, "offsetParam")
    @test haskey(parameters, "limitParam")

    requestBodies = components["requestBodies"]
    @test haskey(requestBodies, "NewItem")

    responses = components["responses"]
    @test haskey(responses, "GeneralError")

    headers = components["headers"]
    @test haskey(headers, "X-RateLimit-Limit")
    @test haskey(headers, "X-RateLimit-Remaining")

    examples = components["examples"]
    @test haskey(examples, "tshirt")

    links = components["links"]
    @test haskey(links, "GetUserByUserId")

    callbacks = components["callbacks"]
    @test haskey(callbacks, "myEvent")
end

@testset "Build directly through Dict" begin
    @swagger """
    /test_swagger_dict:
        post:
            description: Testing swagger markdown test!
            responses:
                '200':
                    description: Returns a mysterious string test.
    """
    
    # https://support.smartbear.com/swaggerhub/docs/en/domains/openapi-3-0-domain-example.html
    @swagger_schemas """
    ErrorModel_dict:
        type: object
        required:
            - code
            - message
        properties:
            code:
                type: integer
                format: int32
            message:
                type: string
    """

    @swagger_parameters """
    offsetParam_dict:
        name: offset
        in: query
        schema:
            type: integer
            minimum: 0
        description: The number of items to skip before returning the results
    limitParam_dict:
        in: query
        name: limit
        schema:
            type: integer
            format: int32
            minimum: 1
            maximum: 100
            default: 20
        description: The number of items to return
    """

    @swagger_requestBodies """
    NewItem_dict:
        description: A JSON object containing item data
        required: true
        content:
            application/json:
                schema:
                    type: object
                examples:
                    tshirt:
                        \$ref: '#/components/examples/tshirt_dict'
    """

    @swagger_responses """
    GeneralError_dict:
        description: An error occurred
        content:
            application/json:
                schema:
                    \$ref: '#/components/schemas/ErrorModel_dict'
        headers:
            X-RateLimit-Limit:
                \$ref: '#/components/headers/X-RateLimit-Limit_dict'
            X-RateLimit-Remaining:
                \$ref: '#/components/headers/X-RateLimit-Remaining_dict'
    """

    @swagger_headers """
    X-RateLimit-Limit_dict:
        description: Request limit per hour
        schema:
            type: integer
        example: 100
    X-RateLimit-Remaining_dict:
        description: Remaining requests for the hour
        schema:
            type: integer
        example: 94
    """

    @swagger_examples """
    tshirt_dict:
        summary: Sample T-shirt data
        value:
            # Example value starts here
            id: 17
            name: T-shirt
            description: 100% cotton shirt
            categories: [clothes]
    """

    # https://swagger.io/docs/specification/links/
    @swagger_links """
    GetUserByUserId_dict:   # <---- arbitrary name for the link
        operationId: getUser
        parameters:
            userId: '\$response.body#/id'
        description: >
            The `id` value returned in the response can be used as
            the `userId` parameter in `GET /users/{userId}`.
    """

    # https://swagger.io/docs/specification/callbacks/
    @swagger_callbacks"""
    myEvent_dict:   # Event name
        '{\$request.body#/callbackUrl}':   # The callback URL,
                                        # Refers to the passed URL
            post:
                requestBody:   # Contents of the callback message
                    required: true
                    content:
                        application/json:
                            schema:
                                type: object
                                properties:
                                    message:
                                        type: string
                                        example: Some event happened
                                required:
                                    - message
                responses:   # Expected responses to the callback message
                    '200':
                        description: Your server returns this code if it accepts the callback
    """

    spec = Dict{String, Any}([
        "info" => Dict{String, Any}([
            "version" => "3.0",
            "title" => "API example"
        ]),
        "openapi" => "3.0"
    ])
    spec = build(spec)
    @test haskey(spec, "paths")

    components = spec["components"]

    schemas = components["schemas"]
    @test haskey(schemas, "ErrorModel_dict")

    parameters = components["parameters"]
    @test haskey(parameters, "offsetParam_dict")
    @test haskey(parameters, "limitParam_dict")

    requestBodies = components["requestBodies"]
    @test haskey(requestBodies, "NewItem_dict")

    responses = components["responses"]
    @test haskey(responses, "GeneralError_dict")

    headers = components["headers"]
    @test haskey(headers, "X-RateLimit-Limit_dict")
    @test haskey(headers, "X-RateLimit-Remaining_dict")

    examples = components["examples"]
    @test haskey(examples, "tshirt_dict")

    links = components["links"]
    @test haskey(links, "GetUserByUserId_dict")

    callbacks = components["callbacks"]
    @test haskey(callbacks, "myEvent_dict")
end

@testset "Build OpenAPI correctly" begin
    @swagger """
    /test_api:
        post:
            description: Testing swagger markdown test!
            responses:
                '200':
                    description: Returns a mysterious string test.
    """

    # https://support.smartbear.com/swaggerhub/docs/en/domains/openapi-3-0-domain-example.html
    @swagger_schemas """
    ErrorModel_api:
        type: object
        required:
            - code
            - message
        properties:
            code:
                type: integer
                format: int32
            message:
                type: string
    """

    @swagger_parameters """
    offsetParam_api:
        name: offset
        in: query
        schema:
            type: integer
            minimum: 0
        description: The number of items to skip before returning the results
    limitParam_api:
        in: query
        name: limit
        schema:
            type: integer
            format: int32
            minimum: 1
            maximum: 100
            default: 20
        description: The number of items to return
    """

    @swagger_requestBodies """
    NewItem_api:
        description: A JSON object containing item data
        required: true
        content:
            application/json:
                schema:
                    type: object
                examples:
                    tshirt:
                        \$ref: '#/components/examples/tshirt_api'
    """

    @swagger_responses """
    GeneralError_api:
        description: An error occurred
        content:
            application/json:
                schema:
                    \$ref: '#/components/schemas/ErrorModel_api'
        headers:
            X-RateLimit-Limit:
                \$ref: '#/components/headers/X-RateLimit-Limit_api'
            X-RateLimit-Remaining:
                \$ref: '#/components/headers/X-RateLimit-Remaining_api'
    """

    @swagger_headers """
    X-RateLimit-Limit_api:
        description: Request limit per hour
        schema:
            type: integer
        example: 100
    X-RateLimit-Remaining_api:
        description: Remaining requests for the hour
        schema:
            type: integer
        example: 94
    """

    @swagger_examples """
    tshirt_api:
        summary: Sample T-shirt data
        value:
            # Example value starts here
            id: 17
            name: T-shirt
            description: 100% cotton shirt
            categories: [clothes]
    """

    # https://swagger.io/docs/specification/links/
    @swagger_links """
    GetUserByUserId_api:   # <---- arbitrary name for the link
        operationId: getUser
        parameters:
            userId: '\$response.body#/id'
        description: >
            The `id` value returned in the response can be used as
            the `userId` parameter in `GET /users/{userId}`.
    """

    # https://swagger.io/docs/specification/callbacks/
    @swagger_callbacks"""
    myEvent_api:   # Event name
        '{\$request.body#/callbackUrl}':   # The callback URL,
                                        # Refers to the passed URL
            post:
                requestBody:   # Contents of the callback message
                    required: true
                    content:
                        application/json:
                            schema:
                                type: object
                                properties:
                                    message:
                                        type: string
                                        example: Some event happened
                                required:
                                    - message
                responses:   # Expected responses to the callback message
                    '200':
                        description: Your server returns this code if it accepts the callback
    """
    
    info = Dict{String, Any}()
    info["title"] = "Swagger Petstore"
    info["version"] = "1.0.5"
    openApi = OpenAPI("3.0", info)

    spec = build(openApi)

    @assert haskey(spec, "openapi")
    @assert haskey(spec, "paths")
    @assert haskey(spec, "info")

    @test openApi.version == "3.0"
    @test openApi.info["title"] == "Swagger Petstore"
    @test openApi.info["version"] == "1.0.5"

    paths = spec["paths"]

    TEST = "/test_api"
    @test haskey(paths, TEST)

    r = paths[TEST]
    @test haskey(r, POST)
    @assert haskey(r[POST], "description")
    @test r[POST]["description"] == "Testing swagger markdown test!"
    @assert haskey(r[POST], "responses")
    @assert haskey(r[POST]["responses"], "200")
    @assert haskey(r[POST]["responses"]["200"], "description")
    @test r[POST]["responses"]["200"]["description"] == "Returns a mysterious string test."

    components = spec["components"]

    schemas = components["schemas"]
    @test haskey(schemas, "ErrorModel_api")

    parameters = components["parameters"]
    @test haskey(parameters, "offsetParam_api")
    @test haskey(parameters, "limitParam_api")

    requestBodies = components["requestBodies"]
    @test haskey(requestBodies, "NewItem_api")

    responses = components["responses"]
    @test haskey(responses, "GeneralError_api")

    headers = components["headers"]
    @test haskey(headers, "X-RateLimit-Limit_api")
    @test haskey(headers, "X-RateLimit-Remaining_api")

    examples = components["examples"]
    @test haskey(examples, "tshirt_api")

    links = components["links"]
    @test haskey(links, "GetUserByUserId_api")

    callbacks = components["callbacks"]
    @test haskey(callbacks, "myEvent_api")
end