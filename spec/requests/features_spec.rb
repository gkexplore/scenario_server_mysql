require 'rails_helper'

describe "feature", :type => :feature do
  describe "Manage Feature" do
    it "Adds a new contact and displays the results" do
      visit '/features'
      expect{
        click_link 'New Feature'
        fill_in 'feature[feature_name]', :with => 'feature1'
        click_button "Create Feature"
      }.to change(Feature,:count).by(1)
      expect(page).to have_content "The feature has been created successfully!!!"
      expect(page).to have_content "feature1"
    end
  end
end