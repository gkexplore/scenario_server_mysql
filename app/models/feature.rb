class Feature < ActiveRecord::Base
	has_many:flows
	validates :feature_name, presence: true,
                    length: { minimum: 1 }
end
