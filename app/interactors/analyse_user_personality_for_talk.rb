class AnalyseUserPersonalityForTalk
    include Interactor

    ANALYSE_USER_PERSONALITY_FOR_TALK_PROMPT = <<~PROMPT
    #命令書：
        あなたはメンタルカウンセラーです。
        以下の制約条件と入力文をもとに、ユーザーの性格を分析してください。
        性格は「うさぎ」の数で表します。たとえば外向性＋が高ければ「いそぎうさぎ」がたくさん、外向性－が低ければ「ゆっくりうさぎ」がすくない。
    #制約条件：
        ・文字数は300文字まで
        ・フレンドリーでわかりやすい説明を心がける
        ・うさぎの具体的な数は回答に含めない
    #回答例：
        あなたの心には「いそぎうさぎ」と「あったかうさぎ」がたくさん住んでいるんだね。いそぎうさぎは、社交的で積極的な性格だと思うよ。友達がたくさんいて、いろいろな人と関わっているんだろうね。あったかうさぎも多いから、みんなに優しく接することができるんだね。困っている人を見ると、すぐに助けてあげたくなる性格だと思うよ。でも、時には他の人を利用して自分の都合の良いように行動することもあるかもしれないから、気をつけてね。
    PROMPT

    def call
        user = context.user

        if user.user_personality.memo.nil?
            AnalyseUserPersonality.call(user: user)
        end

        messages = [
            {
                "role": "system",
                "content": [
                    {
                        "text": ANALYSE_USER_PERSONALITY_FOR_TALK_PROMPT + "#ユーザーの性格\n" + user.user_personality.memo,
                        "type": "text"
                    }
                ]
            },
            {
                "role": "assistant",
                "content": [
                    {
                        "text": OpenAiSetting::ABOUT_PERSONALITY_PROMPT,
                        "type": "text"
                    }
                ]
            }
        ]

        openai_client = OpenAI::Client.new
        response = openai_client.chat(
            parameters: {
                model: "gpt-4o-mini",
                messages: messages,
                temperature: 0.7,
            }
        )
        text = response.dig("choices", 0, "message", "content")

        # TalkLog.create(user_id: context.user.id, role: "assistant", content: text)
        context.reply_message = ReplyMessage::Text.call(text: text).reply_message
    end
end