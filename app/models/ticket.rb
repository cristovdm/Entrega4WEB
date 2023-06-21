class Ticket < ApplicationRecord
  belongs_to :normal_user, class_name: 'User'
  belongs_to :executive_user, class_name: 'User'
  has_many :comments
  validates :title, presence: true
  validates :description, presence: true
  validates :tags, presence: true
  validates :mark, inclusion: { in: 1..5, message: "must be between 1 and 5" }, allow_nil: true
  enum priority: { urgent: 0, high: 1, normal: 2, low: 3 }
end