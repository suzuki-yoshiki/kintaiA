class Base < ApplicationRecord
  belongs_to :user
  
  validates :base_name,  presence: true
  validates :base_type,  presence: true
  validates :base_number,  presence: true
end
