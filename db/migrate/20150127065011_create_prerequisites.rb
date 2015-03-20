class CreatePrerequisites < ActiveRecord::Migration
  def change
    create_table :prerequisites do |t|
      t.text :service_array_comma_separated
      t.text :created_at
      t.text :updated_at
      t.references :flow, index: true

      t.timestamps null: false
    end
    add_foreign_key :prerequisites, :flows
  end
end
