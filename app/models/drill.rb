class Drill < ApplicationRecord
  enum status: {
    published: 0,
    draft: 1
  }

  belongs_to :author, class_name: 'User'
  belongs_to :editor, class_name: :User, optional: true
  belongs_to :topic

  has_many :attempts, dependent: :destroy
  has_many :tallies, dependent: :destroy
end
