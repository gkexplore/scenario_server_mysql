class Feature < ActiveRecord::Base
	has_many:flows, dependent: :destroy
	validates :feature_name, presence: true, uniqueness: true,
                    length: { minimum: 1 }

      def self.export_all_as_xml
      	 @features = Feature.all.includes({:flows =>{:scenarios => :routes}}).joins({:flows =>{:scenarios => :routes}})
			   file_name = Time.now.to_s<<".xml"
			   @features.to_xml(:include => {:flows => {:include => {:scenarios =>{:include =>:routes}}}})
      end   

      def self.export_as_xml(feature_ids)
      	  @features = Feature.where(:id=>feature_ids).includes({:flows =>{:scenarios => :routes}}).joins({:flows =>{:scenarios => :routes}})
      	  @features.to_xml(:include => {:flows => {:include => {:scenarios =>{:include =>:routes}}}})
      end
end
