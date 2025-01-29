### Methods
#### OpenAI.new(options: OpenAIConfig) — Creates a new OpenAI client instance.

***Parameters:***
* `Options: OpenAIConfig` - Configuration for OpenAI client.
    * `apiKey` - Auth token for requests. Required.
    * `baseURL` - Base URL for API requests. Defaults to OpenAI's base URL.
    * `timeout` - Time in miliseconds before halting (through the API, not module). Defaults to 60 * 1000 seconds
    * `endpoints` - Custom endpoints for API requests. Will automatically merge undefined endpoints with a default endpoint table.

***Returns:***

* New OpenAI client instance.

***Example:***
```lua
local OpenAI = require("./path/to/openai")

local openai = OpenAI.new({
    apiKey = "your-api-key",
    baseURL = "https://api.openai.com/v1",
    timeout = 30000,
    endpoints = {
        chatCompletion = "/chat/completions",
        listModels = "/models"
    }
})
```

#### OpenAI:CreateChatCompletion(request: ChatCompletionRequest) — Creates a chat completion.

***Parameters:***

* `request` - Request for chat completion.
    * `model` - The model to use for the request.
    * `messages` - Array of ChatMessage types.
        * `role` - The role of the message.
        * `content` - The contents of the message
        * `name` - Optional name of participant
        * `refusal` - Assistant messages only. Reason that model refused a message.
        * `tool_calls` - Assistant messages only. Tools called on that message.
        * `tool_call_id` - Tool message only. 
    * `max_completion_tokens` - Optional: Maximum tokens for completion
    * `temperature` - Optional: How creative/random the output will be. Lower for more focused, higher for more creativity.
    * `top_p` - Optional: (a.k.a. nucleus sampling). Controls randomness by selecting the smallest set of tokens whose combined probability exceeds top_p. Lower top_p makes output more focused; higher top_p increases diversity.
    * `seed` - Optional: For predictable outputs. Same seeds will produce same outputs.
    * `generations` - Optional: How many generations to complete.
    * `tools` - Optional: Tools available to the model.
    * `tool_choice` - Optional: Controls which tools the model will use during generation. Can either be none for no choices, auto to let the AI choose, required to require it to use at least one tool, or you can pass a tool object to force it to use that tool.


***Returns:***

* `ChatCompletionResponse`: Successful API response.
    * `id` - Snowflake for that specific request.
    * `choices` - Array of response choices. `generations` in the ChatCompletionRequest determines how many choices are generated.
    * `created` - Unix timestamp (seconds) of when the completion was created.
    * `model` - The model used for generation.
    
***Example:***
```lua
local response = openai:CreateChatCompletion({
	model = "gpt-4o-mini",
    messages = {
        {
            role = "user",
            content = "Hello, how are you?"
        }
	},
	temperature = 1,
	max_completion_tokens = 4096
})
```


#### OpenAI:CreateModeration() — Classifies text that are potentially harmful.

***Parameters:***

* `input` - Either a single string or array of strings to be processed.
* `model` - Optional model parameter. Recommended to keep this blank.

***Returns:***

* `ModerationResponse`
    * `id` - Snowflake for that specific request.
    * `model` - Model used during request.
    * `results` - List ModerationResult types corresponding with array index on input.
        * `flagged` - Boolean, whether any of the categories were flagged.
        * `categories` - Array of boolean values with a list of categories, whether they were flagged or not.
        * `category_scores` - Array of boolean values with certainty for each category.

Moderation categories and their definitions can be found at the [OpenAI Documentation](https://platform.openai.com/docs/api-reference/moderations/object).

***Example:***
```lua
local moderationResult = openai:CreateModeration({
	"I hope you die.", "I love you so much!"
})
print(moderationResult.results[1].flagged) -- True
print(moderationResult.results[2].flagged) -- False
```

#### OpenAI:GetAvailableModels() — Get a list of available text generation models

***Returns:***

* List of `model` objects   
    * `id` - Snowflake for this model. Is what is used in the `model` parameter for chat completions.
    * `created` - Unix timestamp (seconds) when the model was created.
    * `object` - Always model.
    * `owned_by` - Organization that owns the model.

***Example:***
```lua
local models = openai:GetAvailableModels()
```