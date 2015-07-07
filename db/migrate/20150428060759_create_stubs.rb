class CreateStubs < ActiveRecord::Migration
  def change
    create_table :stubs do |t|
      t.text :request_url
      t.text :route_type
      t.text :request_body
      t.text :response
      t.text :status
      t.text :host

      t.timestamps null: false
    end
     change_column :stubs, :request_url, :text, :limit => 4294967295
     change_column :stubs, :route_type, :text, :limit => 4294967295
     change_column :stubs, :request_body, :text, :limit => 4294967295
     change_column :stubs, :response, :text, :limit => 4294967295
     change_column :stubs, :status, :text, :limit => 4294967295
     change_column :stubs, :host, :text, :limit => 4294967295
     add_column :stubs, :remote_ip, :text, :limit => 4294967295
     add_column :stubs, :headers, :text, :limit => 4294967295
  end
end
