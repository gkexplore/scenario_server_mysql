class RenameConfigsToAadhiConfigs < ActiveRecord::Migration
  def change
      rename_table :configs, :aadhiconfigs
  end
end
