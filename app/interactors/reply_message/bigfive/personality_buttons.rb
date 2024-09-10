class ReplyMessage::Bigfive::PersonalityButtons
    include Interactor

    # context
    
    def call
        reply_message = {
            type: "template",
            altText: "性格診断結果",
            template: {
                type: "buttons",
                text: "性格診断の分析が終わったよ！",
                actions: [
                    {
                        type: "postback",
                        label: '診断の結果を聞く',
                        data: "action=personality",
                        displayText: '診断の結果を聞く'
                    },
                    {
                        type: "postback",
                        label: '他の診断をしてみる',
                        data: "action=other",
                        displayText: '他の診断をしてみる'
                    }
                ]
            }
        }
        context.reply_message = reply_message
    end
end