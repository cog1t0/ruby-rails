class ReplyMessage::Text
    include Interactor

    # context
    #   text
    
    def call
        reply_message = {
            type: "text",
            text: context.text
        }
        context.reply_message = reply_message
    end
end