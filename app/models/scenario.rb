class Scenario < ActiveRecord::Base
  has_many:routes, dependent: :destroy
  belongs_to :flow
end
