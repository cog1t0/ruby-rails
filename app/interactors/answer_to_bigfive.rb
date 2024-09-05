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
                reply_message << {
                    type: "text",
                    text: "おつかれさまでした！"
                }

                context.reply_message = reply_message
                return
            end

            # 初回
            if user_choice_id.nil?
                user.big_five_progress.update(next_question_id: Question.big_five.first.id)
                # 回答開始のメッセージを作成
                reply_message << {
                    type: "text",
                    text: "性格診断をはじめるよ！考えこまないでこたえてね！"
                }
            else
                # 2回目以降
                # 回答の保存
                answer = Answer.create(user_id: user.id, choice_id: user_choice_id)
                user.big_five_progress.answer_question(answer)
                user.user_personality.update_point(answer)
            end

            # 次の質問の取得
            question = Question.find(user.big_five_progress.next_question_id)
            choice1 = question.choices[0]
            choice2 = question.choices[1]

            # 質問の表示
            reply_message << {
                type: "text",
                text: question.title
            }

            # 選択肢の表示
            reply_message << {
                type: "text",
                text: "1. #{choice1.text}\n2. #{choice2.text}" 
            }

            # 選択肢のボタン
            reply_message << {
                type: "template",
                altText: question.title,
                template: {
                    type: "buttons",
                    text: "自分の考えに近いものを選んでね",
                    actions: [
                        {
                            type: "postback",
                            label: '1だと思う',
                            data: "action=bigfive&user_choice_id=#{choice1.id}"
                        },
                        {
                            type: "postback",
                            label: '2だと思う',
                            data: "action=bigfive&user_choice_id=#{choice2.id}"
                        }
                    ]
                }
            }

            context.reply_message = reply_message
        rescue => error
            Rails.logger.error(error)

            reply_message = []
            reply_message << {
                type: "text",
                text: "ちょっと調子が悪いみたい。しばらくしてから、もう一度ためしてね。"
            }
            context.reply_message = reply_message
            context.fail!
        end
    end
end