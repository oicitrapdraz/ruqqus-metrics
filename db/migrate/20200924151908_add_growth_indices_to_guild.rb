class AddGrowthIndicesToGuild < ActiveRecord::Migration[6.0]
  def change
    add_index :guilds, :week_growth
    add_index :guilds, :month_growth
  end
end
