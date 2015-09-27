class CreateTestcases < ActiveRecord::Migration
  def change
    create_table :testcases do |t|
      t.string :description
      t.string :status
      t.references :report_device, index: true

      t.timestamps null: false
    end
    add_foreign_key :testcases, :report_devices
  end
end
