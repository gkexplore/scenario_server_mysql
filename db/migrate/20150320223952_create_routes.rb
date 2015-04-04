class CreateRoutes < ActiveRecord::Migration
  def change
    create_table :routes do |t|
      t.string :route_type
      t.text :path
      t.text :query
      t.text :request_body
      t.text :fixture
      t.string :status , :default => '200'
      t.references :scenario, index: true
      t.timestamps null: false
    end
    add_foreign_key :routes, :scenarios
    change_column :routes, :fixture, :text, :limit => 4294967295
    change_column :routes, :query, :text, :limit => 4294967295
    change_column :routes, :request_body, :text, :limit => 4294967295
    change_column :routes, :path, :text, :limit => 4294967295
    add_column :routes, :host, :text, :limit => 4294967295
  end
end
