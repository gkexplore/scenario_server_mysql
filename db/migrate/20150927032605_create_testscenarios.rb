class CreateTestscenarios < ActiveRecord::Migration
  def change
    create_table :testscenarios do |t|
      t.string :scenario_name
      t.string :status
      t.references :report_device, index: true

      t.timestamps null: false
    end
    add_foreign_key :testscenarios, :report_devices
  end
end
