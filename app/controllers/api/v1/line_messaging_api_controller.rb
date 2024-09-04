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
                            # AIとの会話を生成
                            result = TalkWithAi.call(user: user, user_message: event.message['text'])
                            reply_message = result.reply_message
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