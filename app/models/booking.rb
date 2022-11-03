require 'date'

class Booking < ApplicationRecord
  belongs_to :book
  belongs_to :user

  validates :start_date, comparison: { greater_than: Date.new, message: "Start date should be a date after today." }
  validates :end_date, comparison: { greater_than: :start_date, message: "End date should be a date after start date." }
  validate :start_date_cannot_be_in_the_past

  def start_date_cannot_be_in_the_past
    errors.add(:start_date, "Start date can't be in the past") if start_date.present? && start_date < Date.today
  end
end
