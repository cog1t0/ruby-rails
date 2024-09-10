class TalkWithAi
    include Interactor

    # context
    #   user
    #   user_message
    def call
        reply_message = []
        begin
            messages = [
                {
                    "role": "system",
                    "content": [
                        {
                            "text": OpenAiSetting::NORMAL_PROMPT,
                            "type": "text"
                        }
                    ]
                }
            ]
            if context.user.user_personality.memo.present?
                messages << {
                    "role": "assistant",
                    "content": [
                        "#ユーザーの性格 " + context.user.user_personality.memo 
                    ]
                }
            end

            talk_logs = TalkLog.where(user_id: context.user.line_id).limit(10)
            talk_logs.each do |talk_log|
                messages << talk_log.build_json
            end
    
            messages << {
                "role": "user",
                "content": [
                    {
                        "text": context.user_message,
                        "type": "text"
                    }
                ]
            }
    
            openai_client = OpenAI::Client.new
            response = openai_client.chat(
                parameters: {
                    model: "gpt-4o-mini",
                    messages: messages,
                    temperature: 0.7,  
                }
            )
    
            TalkLog.create(user_id: context.user.id, role: "user", content: context.user_message)
            text = response.dig("choices", 0, "message", "content")
            TalkLog.create(user_id: context.user.id, role: "assistant", content: text)

            result = ReplyMessage::Text.call(text: text)
            context.reply_message = result.reply_message
        rescue => error
            Rails.logger.error(error)
            result = ReplyMessage::Text.call(text: "ちょっと調子が悪いみたい。しばらくしてから、もう一度お試してね。")
            context.reply_message = result.reply_message
            context.fail!
        end
    end
end
