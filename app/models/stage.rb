class Stage < ApplicationRecord
  belongs_to :program

  has_many :subjects, dependent: :destroy
end
