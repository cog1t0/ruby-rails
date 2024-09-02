require "openai"

OpenAI.configure do |config|
    config.access_token = ENV["OPENAI_API_KEY"]
    config.log_errors = ENV["OPENAI_LOG_ERRORS_FLG"]
end