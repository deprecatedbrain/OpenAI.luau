-- Basic
export type endpoints = {
	chatCompletion: string?,
	listModels: string?,
	moderation: string?
}

export type OpenAIConfig = {
    apiKey: string,
	endpounts: endpoints?,
    baseURL: string?,
    timeout: number?
}

-- Chat Completions
export type ChatMessage = {
	role: "system" | "user" | "assistant" | "developer" | "tool" | string,
	content: string | {},
	name: string?,

	-- Assistant message only.
	refusal: string,
	tool_calls: {}?,

	-- Tool message only.
	tool_call_id: string?
}

export type ChatCompletionRequest = {
	model: string,
	messages: { ChatMessage },
	max_completion_tokens: number?,
	temperature: number?,
	top_p: number?,
	seed: number?,
	generations: number?,
	tools: {}?,
	tool_choice: "none" | "auto" | "required" | {}?
}

export type ChatCompletionResponse = {
	id: string,
	choices: { ChatMessage },
	created: number,
	model: string
}

-- Models
export type Model = {
	id: string,
	created: number,
	object: "model",
	owned_by: string,
}

-- Moderation
export type ModerationCategories = {
    harassment: boolean,
    ["harassment/threatening"]: boolean,
    hate: boolean,
    ["hate/threatening"]: boolean,
    illicit: boolean,
    ["illicit/violent"]: boolean,
    ["self-harm"]: boolean,
    ["self-harm/instructions"]: boolean,
    ["self-harm/intent"]: boolean,
    sexual: boolean,
    ["sexual/minors"]: boolean,
    violence: boolean,
    ["violence/graphic"]: boolean,
}

export type ModerationCategoryScores = {
    harassment: number,
    ["harassment/threatening"]: number,
    hate: number,
    ["hate/threatening"]: number,
    illicit: number,
    ["illicit/violent"]: number,
    ["self-harm"]: number,
    ["self-harm/instructions"]: number,
    ["self-harm/intent"]: number,
    sexual: number,
    ["sexual/minors"]: number,
    violence: number,
    ["violence/graphic"]: number,
}

export type CategoryAppliedInputTypes = {
    harassment: {string},
    ["harassment/threatening"]: {string},
    hate: {string},
    ["hate/threatening"]: {string},
    illicit: {string},
    ["illicit/violent"]: {string},
    ["self-harm"]: {string},
    ["self-harm/instructions"]: {string},
    ["self-harm/intent"]: {string},
    sexual: {string},
    ["sexual/minors"]: {string},
    violence: {string},
    ["violence/graphic"]: {string},
}

export type ModerationResult = {
	flagged: boolean,
    categories: ModerationCategories,
    category_scores: ModerationCategoryScores
}

export type ModerationResponse = {
	id: string,
	model: string,
	results: { ModerationResult }
}

return {}