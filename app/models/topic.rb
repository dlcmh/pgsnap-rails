class Topic < ApplicationRecord
  enum status: %i[in_progress completed]

  belongs_to :subject

  has_many :drills, dependent: :destroy
end
