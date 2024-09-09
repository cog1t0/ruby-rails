require 'net/http'
require 'uri'
require 'json'

class LoadingAnimation::LoadingAnimation
    include Interactor

    # context
    #   chatId
    
    def call
        uri = URI.parse("https://api.line.me/v2/bot/chat/loading/start")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        request = Net::HTTP::Post.new(uri.request_uri)
        request["Content-Type"] = "application/json"
        request["Authorization"] = "Bearer #{ENV['LINE_CHANNEL_ACCESS_TOKEN']}"
        request.body = JSON.dump({
            "chatId" => context.chatId,
            "loadingSeconds" => 5
        })
        http.request(request)
    end
end

