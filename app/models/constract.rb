class Constract < ActiveRecord::Base
  before_save :initialize_total_money, :decrease_tour_available_tickets

  belongs_to :tour

  validates :tour, presence: true
  validates :customer_id_number, presence: true
  validates :company_name, presence: true
  validates :company_phone, presence: true
  validates :company_address, presence: true

  validate :booking_tickets_validation

  private
  def booking_tickets_validation
    return unless tour.present?
    case
    when !booking_tickets.is_a?(Integer)
      errors.add :booking_tickets, message: I18n.t("errors.not_integer")
    when booking_tickets < 1
      errors.add :booking_tickets,
        message: I18n.t("errors.greater_than", number: 0)
    when booking_tickets > self.tour.available_tickets
      errors.add :booking_tickets,
        message: I18n.t("errors.less_than_attr", attr: "available_tickets")
    end
  end

  def initialize_total_money
    self.total_money = tour.cost * booking_tickets
  end

  def decrease_tour_available_tickets
    self.tour.update! available_tickets: (tour.available_tickets - booking_tickets)
  end
end
