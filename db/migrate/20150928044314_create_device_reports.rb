class CreateDeviceReports < ActiveRecord::Migration
  def change
    create_table :device_reports do |t|
      t.string :device_ip

      t.timestamps null: false
    end
  end
end
