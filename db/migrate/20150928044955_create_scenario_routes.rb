class CreateScenarioRoutes < ActiveRecord::Migration
  def change
    create_table :scenario_routes do |t|
      t.string :path
      t.string :route_type
      t.text :fixture
      t.integer :count, :default=>0
      t.references :device_scenario, index: true

      t.timestamps null: false
    end
    add_foreign_key :scenario_routes, :device_scenarios
    change_column :scenario_routes, :fixture, :text, :limit => 4294967295
    change_column :scenario_routes, :path, :text, :limit => 4294967295
    add_column :scenario_routes, :status, :string
  end
end
