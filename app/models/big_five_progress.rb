class BigFiveProgress < ApplicationRecord
    belongs_to :user

    def answer_question(answer)
        question = answer.choice.question
        self.current_question_id = question.id
        self.next_question_id = question.next_big_five_question.id
        self.finished = true if self.next_question_id.nil?
        self.save
    end
end
