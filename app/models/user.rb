class User < ApplicationRecord
    has_many :answers
    has_one :big_five_progress
    has_one :user_personality

    after_create :create_options

    def create_options
        UserPersonality.create(user_id: self.id)
        BigFiveProgress.create(user_id: self.id, current_question_id: 1)
    end
end
