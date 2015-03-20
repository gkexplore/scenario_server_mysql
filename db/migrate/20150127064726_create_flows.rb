class CreateFlows < ActiveRecord::Migration
  def change
    create_table :flows do |t|
      t.text :name
      t.text :created_at
      t.text :updated_at

      t.timestamps null: false
    end
  end
end
