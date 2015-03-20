class Scenario < ActiveRecord::Base
  has_many:routes
  belongs_to :flow
end
