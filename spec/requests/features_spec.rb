require 'rails_helper'

describe "feature", :type => :feature do
  describe "Manage Feature" do
    it "Adds a new contact and displays the results", :js => true do
      visit '/features'
        click_link 'New Feature'
        fill_in 'feature[feature_name]', :with => 'feature1'
        click_button "Create Feature"
      expect(page).to have_content "The feature has been created successfully!!!"
      expect(page).to have_content "feature1"
      expect(page).to have_submit_button "Create Flow"
      expect(page).to have_content "Flow Name"
    end
  end
end

RSpec::Matchers.define :have_submit_button do |value|
  match do |actual|
    expect(actual).to have_selector("input[type=submit][value='#{value}']")
  end
end