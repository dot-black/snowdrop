class Discount < ApplicationRecord
  has_many :products

  validates_presence_of :title, :value
  validates :value, numericality: { greater_than: 0, less_than: 100 }

  def actual
    if start_at && end_at
      Time.now.between? start_at, end_at
    elsif start_at || end_at
      start_at < Time.now if start_at
      end_at > Time.now if end_at
    else
      true
    end
  end
end
