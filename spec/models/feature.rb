require "rails_helper"

RSpec.describe Feature, :type => :model do
  context "with 2 or more features" do
    it "should add two items" do
      feature1 = Feature.create(:feature_name => "first feature")
      feature2 = Feature.create(:feature_name => "second feature")
      expect(Feature.count).to eq(2)
    end
  end
end