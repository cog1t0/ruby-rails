class AnswerToBigfive
    include Interactor

    # context
    #   user
    #   user_choice_id
    
    def call
        begin
            user = context.user
            user_choice_id = context.user_choice_id
            reply_message = []

             # 次の質問の準備
             if user.big_five_progress.finished?
                # 終了
                reply_message << ReplyMessage::Text.call(text: "おつかれさまでした！\n診断結果を計算するからすこし待ってね！")

                context.reply_message = reply_message
                return
            end

            # リッチメニューから性格診断を実施
            if user_choice_id.nil?
                if user.answers.count == 0
                    # 回答開始のメッセージを作成
                    reply_message << ReplyMessage::Text.call(text: "性格診断をはじめるよ！考えこまないでこたえてね！")
                end
                # 次の質問の取得
                question = Question.find(user.big_five_progress.current_question_id)
            else
                # 2回目以降
                # 回答の保存
                if user.big_five_progress.in_order?(user_choice_id)
                    answer = Answer.create(user_id: user.id, choice_id: user_choice_id)
                    user.big_five_progress.answer_question(answer)
                    user.user_personality.update_point(answer)
                    # 次の質問の取得
                    question = Question.find(user.big_five_progress.next_question_id)
                else
                    reply_message << ReplyMessage::Text.call(text: "順番通りに回答してね！")
                    # 順番通りの質問を取得
                    question = Question.find(user.big_five_progress.current_question_id)
                end
            end

            choice1 = question.choices[0]
            choice2 = question.choices[1]

            # 質問の表示
            reply_message << ReplyMessage::Text.call(text: "Q.#{question.id} #{question.title}")

            # 選択肢の表示
            reply_message << ReplyMessage::Text.call(text: "1. #{choice1.text}\n2. #{choice2.text}")

            # 選択肢のボタン
            reply_message << ReplyMessage::Bugfive::Buttons.call(question: question, choice1: choice1, choice2: choice2)

            context.reply_message = reply_message
        rescue => error
            Rails.logger.error(error)

            reply_message = []
            reply_message << ReplyMessage::Text.call(text: "ちょっと調子が悪いみたい。しばらくしてから、もう一度ためしてね。")
            context.reply_message = reply_message
            context.fail!
        end
    end
end