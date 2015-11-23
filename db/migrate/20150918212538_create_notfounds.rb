class CreateNotfounds < ActiveRecord::Migration
  def change
    create_table :notfounds do |t|
      t.string :url
      t.string :scenario_name
      t.string :device_ip
      t.string :method

      t.timestamps null: false
    end
    change_column :notfounds, :url, :text, :limit => 4294967295
  end
end
