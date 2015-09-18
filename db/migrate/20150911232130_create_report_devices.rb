class CreateReportDevices < ActiveRecord::Migration
  def change
    create_table :report_devices do |t|
      t.string :device_ip

      t.timestamps null: false
    end
  end
end
