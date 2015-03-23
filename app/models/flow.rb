class Flow < ActiveRecord::Base
 validates :flow_name, presence: true, uniqueness: true,
                    length: { minimum: 1 }
  has_many:scenarios, dependent: :destroy
  belongs_to :feature
end
