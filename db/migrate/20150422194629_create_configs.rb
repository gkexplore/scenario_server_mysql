class CreateConfigs < ActiveRecord::Migration
  def change
    create_table :configs do |t|
      t.timestamps null: false
    end
    add_column :configs, :server_mode, "enum('default','record','refresh')", :default => 'default'
  end
end
