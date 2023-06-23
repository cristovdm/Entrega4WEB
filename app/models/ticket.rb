class Ticket < ApplicationRecord
  belongs_to :normal_user, class_name: 'User'
  belongs_to :executive_user, class_name: 'User'
  has_many :comments, dependent: :destroy
  validates :title, presence: true
  validates :description, presence: true
  validates :tags, presence: true
  validates :mark, inclusion: { in: 1..5, message: "must be between 1 and 5" }, allow_nil: true
  enum priority: { urgent: 0, high: 1, normal: 2, low: 3 }

  before_create :set_term_at

  private

  def set_term_at
    case priority.to_sym
    when :urgent
      self.term_at = created_at + 1.day
    when :high
      self.term_at = created_at + 2.days
    when :normal
      self.term_at = created_at + 4.days
    when :low
      self.term_at = created_at + 7.days
    end
  end
end