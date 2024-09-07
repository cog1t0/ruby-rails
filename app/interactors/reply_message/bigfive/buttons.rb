class ReplyMessage::Bugfive::Buttons
    include Interactor

    # context
    #   question
    #   choice1
    #   choice2
    
    def call
        reply_message = {
            type: "template",
            altText: context.question.title,
            template: {
                type: "buttons",
                text: "自分の考えに近いものを選んでね",
                actions: [
                    {
                        type: "postback",
                        label: '1だと思う',
                        data: "action=bigfive&user_choice_id=#{context.choice1.id}",
                        displayText: context.choice1.text
                    },
                    {
                        type: "postback",
                        label: '2だと思う',
                        data: "action=bigfive&user_choice_id=#{context.choice2.id}",
                        displayText: context.choice2.text
                    }
                ]
            }
        }
        context.reply_message = reply_message
    end
end