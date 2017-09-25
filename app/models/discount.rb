class Discount < ApplicationRecord
  validates_presence_of :title, :value
  validates :value, numericality: { greater_than: 0, less_than: 100 }

  has_many :products

  def actual
    if start_at and end_at
      Time.now.between? start_at, end_at
    elsif start_at or end_at
      return start_at < Time.now if start_at
      return end_at   > Time.now if end_at
    else
      true
    end
  end
end
