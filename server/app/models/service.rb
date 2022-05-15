class Service < ApplicationRecord
  has_many :workshifts
  has_many :users
end
