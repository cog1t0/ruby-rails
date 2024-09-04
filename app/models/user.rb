class User < ApplicationRecord
    has_many :answers
    has_many :big_five_progresses
end
