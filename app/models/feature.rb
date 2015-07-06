class Feature < ActiveRecord::Base
	has_many:flows, dependent: :destroy
	validates :feature_name, presence: true, uniqueness: true,
                    length: { minimum: 1 }
      def as_json(options={})
      	super(include: { flows: {
                           include: { scenarios: {
                           			include: {routes:{} }}}}})
      end              
end
