class Program < ApplicationRecord
  has_many :stages, dependent: :destroy
  has_many :subjects, through: :stages
  has_many :topics, through: :subjects
  has_many :drills, through: :topics
end
