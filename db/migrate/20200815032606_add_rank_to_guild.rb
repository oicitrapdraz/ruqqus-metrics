class AddRankToGuild < ActiveRecord::Migration[6.0]
  def change
    add_column :guilds, :rank, :integer
  end
end
