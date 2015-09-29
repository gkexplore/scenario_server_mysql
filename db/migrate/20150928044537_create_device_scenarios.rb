class CreateDeviceScenarios < ActiveRecord::Migration
  def change
    create_table :device_scenarios do |t|
      t.string :scenario_name
      t.references :device_report, index: true

      t.timestamps null: false
    end
    add_foreign_key :device_scenarios, :device_reports
  end
end
