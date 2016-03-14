class Place < ActiveRecord::Base
  validates :code, presence: true, uniqueness: true, length: {maximum: 20, minimum: 4}
  validates :name, presence: true, uniqueness: true, length: {minimum: 5}
  validates :city, presence: true
  validates :country, presence: true
  validates :address, presence: true
  validates :services, presence: true
end
