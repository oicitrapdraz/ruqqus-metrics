class AddLogoPathToGuild < ActiveRecord::Migration[6.0]
  def change
    add_column :guilds, :logo_path, :string
  end
end
