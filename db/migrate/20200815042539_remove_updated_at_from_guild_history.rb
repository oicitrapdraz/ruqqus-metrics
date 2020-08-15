class RemoveUpdatedAtFromGuildHistory < ActiveRecord::Migration[6.0]
  def change
    remove_column :guild_histories, :updated_at, :datetime
  end
end
