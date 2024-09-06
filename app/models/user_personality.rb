class UserPersonality < ApplicationRecord
    belongs_to :user

    def test
        puts "test"
    end

    def update_point(answer)
        choice = answer.choice
        update(
            p_code_11: p_code_11 + choice.p_code_11,
            p_code_10: p_code_10 + choice.p_code_10,
            p_code_21: p_code_21 + choice.p_code_21,
            p_code_20: p_code_20 + choice.p_code_20,
            p_code_31: p_code_31 + choice.p_code_31,
            p_code_30: p_code_30 + choice.p_code_30,
            p_code_41: p_code_41 + choice.p_code_41,
            p_code_40: p_code_40 + choice.p_code_40,
            p_code_51: p_code_51 + choice.p_code_51,
            p_code_50: p_code_50 + choice.p_code_50
        )
    end
end