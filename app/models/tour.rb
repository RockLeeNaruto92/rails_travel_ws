class Tour < ActiveRecord::Base
  before_create :initialize_available_tickets

  belongs_to :place
  has_many :constracts

  validates :code, presence: true, uniqueness: true
  validates :place_id, presence: true
  validates :start_date, presence: true
  validates :tickets, presence: true,
    numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :cost, presence: true,
    numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :description, presence: true

  has_many :constracts, dependent: :destroy

  private
  def initialize_available_tickets
    self.available_tickets = tickets
  end
end
