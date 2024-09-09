class BigFiveProgress < ApplicationRecord
    belongs_to :user

    def in_order?(choice)
        question = choice.question
        question.id == current_question_id
    end

    def answer_question(answer)
        question = answer.choice.question
        # 順番通りに回答されているかの確認
        if current_question_id == question.id
            self.current_question_id = question.next_big_five_question&.id
            self.next_question_id = question.next_big_five_question&.id
            self.finished = true if self.next_question_id.nil?
            self.save
        else
            return false
        end        
    end
end
