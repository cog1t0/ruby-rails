module Api
    module V1
        class LineMessagingApiController < ActionController::API
            def callback
                body = request.body.read
                events = LINEBOT_CLIENT.parse_events_from(body)

                events.each do |event|
                    Rails.logger.info("==================== event: #{event.inspect}")
                    line_id = event['source']['userId']
                    case event
                    when Line::Bot::Event::Message
                        case event.type
                        when Line::Bot::Event::MessageType::Text
                            user = User.find_or_create_by(line_id: line_id)

                            messages = [
                                {
                                    "role": "system",
                                    "content": [
                                        {
                                            "text": "#命令書：あなたはメンタルカウンセラーです。相談者は「好きなタレント」の話をしてきた場合、相談者の気持ちが盛り上がるような共感を示したりしてください。\n以下の制約条件と入力文をもとに、最高の結果を出力してください。\n#制約条件：\n・文字数は200文字まで\n・フレンドリーな応答を心がける\n#入力文：「聞いて！私の推しが本当にかっこいいの！」\n#出力文：「ほんとかっこいいよね！人間離れしてるかっこよさ！」",
                                            "type": "text"
                                        }
                                    ]
                                }
                            ]
                            talk_logs = TalkLog.where(user_id: user.id).limit(10)
                            talk_logs.each do |talk_log|
                                messages << talk_log.build_json
                            end

                            messages << {
                                "role": "user",
                                "content": [
                                    {
                                        "text": event.message['text'],
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
                            TalkLog.create(user_id: user.id, role: "user", content: event.message['text'])
                            text = response.dig("choices", 0, "message", "content")
                            TalkLog.create(user_id: user.id, role: "assistant", content: text)
                            reply_message = {
                                type: "text",
                                text: text
                            }
                        end
                        LINEBOT_CLIENT.reply_message(event['replyToken'], reply_message)
                    when Line::Bot::Event::Postback
                    when Line::Bot::Event::Follow
                        case event['follow']['isUnblocked']
                        when "false" # フォローされたとき
                            Rails.logger.info("==================== Follow")
                            user = User.find_or_create_by(line_id: line_id)
                            user.update(deleted_at: nil)

                            reply_message = {
                                type: "text",
                                text: 'こんにちは！よろしくね！性格診断をしていくよ！'
                            }
            
                            LINEBOT_CLIENT.reply_message(event['replyToken'], reply_message)
                        when "true" # ブロック解除されたとき
                            Rails.logger.info("==================== UnFollow")
                            user = User.find_by(line_id: line_id)
                            user.update(deleted_at: Time.zone.now)
                        end
                    end
                end
            end
        end
    end
end