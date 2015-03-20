class CreateRoutes < ActiveRecord::Migration
  def change
    create_table :routes do |t|
      t.text :route_type
      t.text :path
      t.text :request_body
      t.text :fixture
      t.text :created_at
      t.text :updated_at
      t.integer :status
      t.references :scenario, index: true

      t.timestamps null: false
    end
    add_foreign_key :routes, :scenarios
  end
end
