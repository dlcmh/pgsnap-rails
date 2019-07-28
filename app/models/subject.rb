class Subject < ApplicationRecord
  belongs_to :stage

  has_many :sessions, dependent: :destroy

  has_many :topics, dependent: :destroy
  has_many :drills, through: :topics
end
