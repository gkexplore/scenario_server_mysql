class CreateConfigs < ActiveRecord::Migration
  def change
    create_table :configs do |t|
      t.timestamps null: false
    end
    add_column :configs, :server_mode, "enum('default','record','refresh')", :default => 'default'
    add_column :configs, :isProxyRequired, "enum('yes','no')", :default => 'no'
    add_column :configs, :url, :text
    add_column :configs, :port, :string
    add_column :configs, :user, :string
    add_column :configs, :password, :string
    add_column :configs, :bypass_proxy_domains, :text
  end
end
