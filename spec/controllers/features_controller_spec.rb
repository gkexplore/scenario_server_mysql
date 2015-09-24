require "rails_helper"

RSpec.describe FeaturesController, :type => :controller do
  describe "GET #index" do
    it "responds successfully with an HTTP 200 status code" do
      get :index
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end

    it "loads all of the features into @features" do
      feature1, feature2 = Feature.create(:feature_name=>"feature1"), Feature.create(:feature_name=>"feature2")
      get :index
      expect(assigns(:features)).to match_array([feature1, feature2])
    end
    
  end
end