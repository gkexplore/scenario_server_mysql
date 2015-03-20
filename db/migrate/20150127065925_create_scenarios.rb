class CreateScenarios < ActiveRecord::Migration
  def change
    create_table :scenarios do |t|
      t.text :name
      t.text :created_at
      t.text :updated_at
      t.references :flow, index: true

      t.timestamps null: false
    end
    add_foreign_key :scenarios, :flows
  end
end
