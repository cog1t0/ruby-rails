class AnalyseUserPersonality
    include Interactor

    ANALYSE_USER_PERSONALITY_PROMPT = <<~PROMPT
    #命令書：
        あなたはメンタルカウンセラーです。
        以下の制約条件と入力文をもとに、ユーザーの性格を分析してください。
        この回答はユーザーに直接渡すものではないので、第三者にわかりやすいように客観的に分析してください。
    #制約条件：
        ・文字数は2000文字まで
        ・第三者に対してわかりやすいよう客観的に分析する
    PROMPT

    def call
        user = context.user

        user_personality_prompt = 
            "#ユーザーの性格 " +
            "##外向性＋：#{user.user_personality.p_code_11}点 " +
            "##外向性－：#{user.user_personality.p_code_10}点 " +
            "##協調性＋：#{user.user_personality.p_code_21}点 " +
            "##協調性－：#{user.user_personality.p_code_20}点 " +
            "##良識性＋：#{user.user_personality.p_code_31}点 " +
            "##良識性－：#{user.user_personality.p_code_30}点 " +
            "##情緒安定性＋：#{user.user_personality.p_code_41}点 " +
            "##情緒安定性－：#{user.user_personality.p_code_40}点 " +
            "##知的好奇心＋：#{user.user_personality.p_code_51}点 " +
            "##知的好奇心－：#{user.user_personality.p_code_50}点"

        messages = [
            {
                "role": "system",
                "content": [
                    {
                        "text": ANALYSE_USER_PERSONALITY_PROMPT + user_personality_prompt,
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

        messages << {
            "role": "user",
            "content": [
                {
                    "text": "ユーザーの性格を分析してください。",
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

        text = response.dig("choices", 0, "message", "content")
        user.user_personality.update(memo: text)
    end
end
