module Api
    module V1
        class LineMessagingApiController < ActionController::API
            def callback
                body = request.body.read
                events = LINEBOT_CLIENT.parse_events_from(body)
                reply_message = []

                events.each do |event|
                    Rails.logger.info("==================== event: #{event.inspect}")
                    line_id = event['source']['userId']
                    user = User.find_or_create_by(line_id: line_id)
                    case event
                    when Line::Bot::Event::Message
                        case event.type
                        when Line::Bot::Event::MessageType::Text
                            # AIとの会話を生成
                            result = TalkWithAi.call(user: user, user_message: event.message['text'])
                            reply_message << result.reply_message
                        end
                        LINEBOT_CLIENT.reply_message(event['replyToken'], reply_message)
                    when Line::Bot::Event::Postback
                        data = event['postback']['data']
                        params = data.split('&').map { |param| param.split('=') }.to_h
                        action = params['action']
                        user_choice_id = params['user_choice_id']

                        Rails.logger.info("==================== action: #{action} / user_choice_id: #{user_choice_id}")

                        case action
                        when 'bigfive'
                            # ビッグファイブの回答のリプライメッセージを生成
                            result = AnswerToBigfive.call(user: user, user_choice_id: user_choice_id)
                            reply_message << result.reply_message
                        else
                            Rails.logger.error("==================== postback error")
                            reply_message << ReplyMessage::Text.call(text: "他の機能は、これから作るから待っててね！")
                        end

                        LINEBOT_CLIENT.reply_message(event['replyToken'], reply_message)

                    when Line::Bot::Event::Follow
                        case event['follow']['isUnblocked']
                        when "false" # フォローされたとき
                            Rails.logger.info("==================== Follow")
                            user = User.find_or_create_by(line_id: line_id)
                            user.update(deleted_at: nil)

                            reply_message << ReplyMessage::Text.call(text: "こんにちは！よろしくね！性格診断をしていくよ！")
            
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