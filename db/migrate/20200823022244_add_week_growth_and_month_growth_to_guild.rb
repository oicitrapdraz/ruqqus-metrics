class AddWeekGrowthAndMonthGrowthToGuild < ActiveRecord::Migration[6.0]
  def change
    add_column :guilds, :week_growth, :integer
    add_column :guilds, :month_growth, :integer
  end
end
