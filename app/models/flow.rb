class Flow < ActiveRecord::Base
  has_many:scenarios, dependent: :destroy
  belongs_to :feature
end
