class Choice < ApplicationRecord
    belongs_to :question
    has_many :answers
end
