class CreateScenarios < ActiveRecord::Migration
  def change
    create_table :scenarios do |t|
      t.string :scenario_name
      t.references :flow, index: true

      t.timestamps null: false
    end
    add_foreign_key :scenarios, :flows
  end
end
