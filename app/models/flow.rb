class Flow < ActiveRecord::Base
  has_many:scenarios
  belongs_to :feature
end
