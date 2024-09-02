class TalkLog < ApplicationRecord
    belongs_to :user

    def build_json
        {
            "role": "#{role}",
            "content": "#{content}"
        }
    end

    def build_text(user, limit=6)
        text = ""
        user.talk_logs.limit(limit).each do |talk_log|
            text += "#{talk_log.role}: #{talk_log.content}\n"
        end
        text
    end
end
