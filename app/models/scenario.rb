class Scenario < ActiveRecord::Base
  validates :scenario_name, presence: true, uniqueness: true,
                    length: { minimum: 1 }
  has_many:routes, dependent: :destroy
  belongs_to :flow
end
