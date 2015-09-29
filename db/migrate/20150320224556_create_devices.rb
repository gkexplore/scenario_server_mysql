class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :device_ip
      t.references :scenario, index: true

      t.timestamps null: false
    end
    add_foreign_key :devices, :scenarios
    add_column :devices, :isReportRequired, "enum('yes','no')", :default => 'no'
  end
end
