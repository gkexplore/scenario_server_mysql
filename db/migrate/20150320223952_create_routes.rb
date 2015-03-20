class CreateRoutes < ActiveRecord::Migration
  def change
    create_table :routes do |t|
      t.string :route_type
      t.string :path
      t.text :query
      t.text :request_body
      t.text :fixture
      t.string :status
      t.references :scenario, index: true

      t.timestamps null: false
    end
    add_foreign_key :routes, :scenarios
  end
end
