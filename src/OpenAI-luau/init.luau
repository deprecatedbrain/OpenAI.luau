local HttpService = game:GetService("HttpService")

local types = require(script:WaitForChild("types"))

local OpenAI = {}
OpenAI.__index = OpenAI

OpenAI.defaultBaseURL = "https://api.openai.com/v1"
OpenAI.defaultEndpoints = {
    chatCompletion = "/chat/completions",
    listModels = "/models",
    moderation = "/moderations"
}

local function mergeEndpoints(provided, default)
    local merged = table.clone(default)

    if provided then
        for key, value in pairs(provided) do
            merged[key] = value
        end
    end
    return merged
end

---@diagnostic disable-next-line: undefined-type
function OpenAI.new(config: types.OpenAIConfig)
    if not HttpService.HttpEnabled then
        error("[OpenAI.luau] HttpService is not enabled!")
    end

    local self = setmetatable({}, OpenAI)

    if not config.baseURL:match("^https?://") then
        error("[OpenAI.luau] baseURL must start with http:// or https://")
    end

    self.baseURL = config.baseURL or OpenAI.defaultBaseURL
    self.timeout = config.timeout or 60 * 1000
    self.endpoints = mergeEndpoints(config.endpoints, OpenAI.defaultEndpoints)
    self.apiKey = config.apiKey

    return self
end

---@diagnostic disable-next-line: undefined-type
function OpenAI:CreateChatCompletion(request: types.ChatCompletionRequest) : types.ChatCompletionResponse
    -- Validate required fields in request
    if not request.model then
        error("[OpenAI.luau] model is required")
    end

    if not request.messages or #request.messages == 0 then
        error("[OpenAI.luau] messages is required")
    end

    local requestBody = {
        model = request.model,
        messages = request.messages,
        max_completion_tokens = request.max_completion_tokens,
        temperature = request.temperature,
        top_p = request.top_p,
        seed = request.seed,
        n = request.generations,
        tools = request.tools,
        tool_choice = request.tool_choice
    }

    for k, v in requestBody do
        if v == nil then
            requestBody[k] = nil
        end
    end

    local success, response = pcall(function()
        return HttpService:RequestAsync({
            Url = `{self.baseURL}{self.endpoints.chatCompletion}`,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
				["Authorization"] = `Bearer {self.apiKey or ""}`
            },
            Body = HttpService:JSONEncode(requestBody)
        })
    end)

    if not success then
        error("[OpenAI.luau] Failed to make request: " .. response)
    end
    if not response.Success or response.StatusCode ~= 200 then
        error("[OpenAI.luau] Request failed with status code: " .. response.StatusCode)
    end

    local parseSuccess, data = pcall(function()
        return HttpService:JSONDecode(response.Body)
    end)

    if not parseSuccess then
        error("[OpenAI.luau] Failed to parse response: " .. data)
    end

    local responsePayload = {
        id = data.id,
        choices = data.choices,
        created = data.created,
        model = data.model
    }

    return responsePayload
end

function OpenAI:CreateModeration(input: string | { string }, model: string?) : types.ModerationResponse
    local requestBody = {
        model = model or "omni-moderation-latest",
        input = input
    }

    local success, response = pcall(function()
        return HttpService:RequestAsync({
            Url = `{self.baseURL}{self.endpoints.moderation}`,
            Method = "POST", 
            Headers = {
                ["Content-Type"] = "application/json",
                ["Authorization"] = `Bearer {self.apiKey or ""}`
            },
            Body = HttpService:JSONEncode(requestBody)
        })
    end)

    if not success then
        error("[OpenAI.luau] Failed to make request: " .. response)
    end
    if not response.Success or response.StatusCode ~= 200 then
        error("[OpenAI.luau] Request failed with status code: " .. response.StatusCode)
    end

    local parseSuccess, data = pcall(function()
        return HttpService:JSONDecode(response.Body)
    end)

    if not parseSuccess then
        error("[OpenAI.luau] Failed to parse response: " .. data)
    end

    data.results.category_applied_input_types = nil -- This is for when using image moderation so it's not needed for this.

    local returnPayload = {
        id = data.id,
        model = data.model,
        results = data.results
    }

    return returnPayload
end

function OpenAI:GetAvailableModels() : { types.Model }
    local success, response = pcall(function()
        return HttpService:RequestAsync({
            Url = `{self.baseURL}{self.endpoints.listModels}`,
            Method = "GET",
            Headers = {
                ["Content-Type"] = "application/json",
                ["Authorization"] = `Bearer {self.apiKey or ""}`
            }
        })
    end)

    if not success then
        error("[OpenAI.luau] Failed to make request: " .. response)
    end
    if not response.Success or response.StatusCode ~= 200 then
        error("[OpenAI.luau] Request failed with status code: " .. response.StatusCode)
    end

    local parseSuccess, data = pcall(function()
        return HttpService:JSONDecode(response.Body)
    end)

    if not parseSuccess or not data.data then
        error("[OpenAI.luau] Failed to parse response: " .. data)
    end

    return data.data
end

return OpenAI