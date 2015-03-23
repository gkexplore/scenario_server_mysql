class Feature < ActiveRecord::Base
	has_many:flows, dependent: :destroy
	validates :feature_name, presence: true, uniqueness: true,
                    length: { minimum: 1 }
end
