class User < ApplicationRecord
  before_create :assign_default_role
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { normal: 0, executive: 1, supervisor: 2, admin: 3 }
  has_many :comments
  has_many :tickets, foreign_key: :normal_user_id
  has_many :executive_tickets, foreign_key: :executive_user_id, class_name: 'Ticket'
  validates :name, :last_name, :telephone, presence: true

  private

  def assign_default_role
    self.role ||= :normal
  end
end
