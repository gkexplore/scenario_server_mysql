class CreateFlows < ActiveRecord::Migration
  def change
    create_table :flows do |t|
      t.string :flow_name
      t.references :feature, index: true

      t.timestamps null: false
    end
    add_foreign_key :flows, :features
    add_index :flows, [:flow_name], :unique => true
  end
end
