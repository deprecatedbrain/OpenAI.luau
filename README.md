# OpenAI.luau
A simple OpenAI API wrapper for Roblox.

[Wally](https://wally.run/package/deprecatedbrain/openai-luau) • [GitHub](https://github.com/deprecatedbrain/OpenAI.luau) • [Roblox Marketplace](https://create.roblox.com/store/asset/90380850667336/OpenAI) • [Documentation](https://github.com/deprecatedbrain/OpenAI.luau/blob/master/DOCUMENTATION.md)

Example:
```lua
local OpenAI = require("./path/to/openai")

-- Creating the OpenAI client
local openai = OpenAI.new({
	apiKey = "your-api-key",
	baseURL = "https://api.openai.com/v1",
	endpoints = {
		chatCompletion = "/chat/completions",
        listModels = "/models",
        moderation = "/moderations"
	}
})

-- Generating a chat completion
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

print(response)

-- Moderation
local moderationResult = openai:CreateModeration({
	"I hope you die", "I love you so much!"
})
print(moderationResult.results[1].flagged) -- True
print(moderationResult.results[2].flagged) -- False

-- Grabbing models
local models = openai:GetAvailableModels()
print(models)
```
