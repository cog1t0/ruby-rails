class Question < ApplicationRecord
    has_many :choices

    scope :big_five, -> { where(:big_five_flg => true)}

    def next_big_five_question
        Question.big_five.where("id > ?", self.id).order(id: :asc).first
    end
end
