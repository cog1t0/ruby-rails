class AnswerToBigfive
    include Interactor

    # context
    #   user
    #   user_choice_id
    
    def call
        begin
            puts "AnswerToBigfive =========="
            user = context.user
            user_choice_id = context.user_choice_id
            reply_message = []

             # 次の質問の準備
             if user.big_five_progress.finished?
                puts "finished =========="
                # 終了
                result = ReplyMessage::Text.call(text: "おつかれさまでした！\n診断結果を計算するからすこし待ってね！")

                context.reply_message = result.reply_message
                return
            end

            # リッチメニューから性格診断を実施
            if user_choice_id.nil?
                puts "user_choice_id = nil =========="
                if user.answers.count == 0
                    # 回答開始のメッセージを作成
                    result = ReplyMessage::Text.call(text: "性格診断をはじめるよ！考えこまないでこたえてね！")
                    reply_message << result.reply_message
                end
                # 次の質問の取得
                question = Question.find(user.big_five_progress.current_question_id)
                puts "user_choice_id = nil ========== question = #{question.inspect}"
            else
                puts "user_choice_id = #{user_choice_id} =========="
                choice = Choice.find(user_choice_id)
                # 2回目以降
                # 回答の保存
                if user.big_five_progress.in_order?(choice)
                    answer = Answer.create(user_id: user.id, choice_id: user_choice_id)
                    user.big_five_progress.answer_question(answer)
                    user.user_personality.update_point(answer)
                    if user.big_five_progress.finished?
                        # 終了
                        result = ReplyMessage::Text.call(text: "おつかれさまでした！\n診断結果を計算するからすこし待ってね！")

                        context.reply_message = result.reply_message
                        return
                    else
                        # 次の質問の取得
                        question = Question.find(user.big_five_progress.next_question_id)
                    end
                else
                    result = ReplyMessage::Text.call(text: "順番通りに回答してね！")
                    reply_message << result.reply_message
                    # 順番通りの質問を取得
                    question = Question.find(user.big_five_progress.current_question_id)
                end
            end

            choice1 = question.choices[0]
            choice2 = question.choices[1]
            puts "choice1 = #{choice1.inspect}"
            puts "choice2 = #{choice2.inspect}"

            # 質問の表示
            result = ReplyMessage::Text.call(text: "Q.#{question.id} #{question.title}")
            reply_message << result.reply_message

            # 選択肢の表示
            result = ReplyMessage::Text.call(text: "1. #{choice1.text}\n2. #{choice2.text}")
            reply_message << result.reply_message

            # 選択肢のボタン
            result = ReplyMessage::Bigfive::Buttons.call(question: question, choice1: choice1, choice2: choice2)
            reply_message << result.reply_message

            puts "reply_message = #{reply_message.inspect}"
            context.reply_message = reply_message
        rescue => error
            Rails.logger.error(error)

            reply_message = []
            result = ReplyMessage::Text.call(text: "ちょっと調子が悪いみたい。しばらくしてから、もう一度ためしてね。")
            context.reply_message = result.reply_message
            context.fail!
        end
    end
end