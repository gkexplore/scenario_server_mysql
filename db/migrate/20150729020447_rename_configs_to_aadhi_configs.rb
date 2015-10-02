class RenameConfigsToAadhiConfigs < ActiveRecord::Migration
  def change
      rename_table :configs, :aadhiconfigs
      Aadhiconfig.create :server_mode=>"default"
  end
end
