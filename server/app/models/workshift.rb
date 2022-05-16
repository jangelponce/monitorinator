class Workshift < ApplicationRecord
  belongs_to :user
  belongs_to :service

  enum :status, [ :pending, :accepted ]  
end
