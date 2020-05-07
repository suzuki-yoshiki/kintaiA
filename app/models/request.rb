class Request < ApplicationRecord
  belongs_to :user
  validates :month, presence: true, allow_blank: true
  validates :mark, presence: true, allow_blank: true
  validates :superior_id, presence: true, allow_blank: true
end
