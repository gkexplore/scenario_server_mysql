class CreateScenarioroutes < ActiveRecord::Migration
  def change
    create_table :scenarioroutes do |t|
      t.string :url
      t.Integer :count
      t.string :method
      t.references :testscenario, index: true

      t.timestamps null: false
    end
    add_foreign_key :scenarioroutes, :testscenarios
  end
end
