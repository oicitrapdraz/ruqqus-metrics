class CreateGuildHistories < ActiveRecord::Migration[6.0]
  def change
    create_table :guild_histories do |t|
      t.references :guild, null: false, foreign_key: true
      t.jsonb :data
      t.integer :rank
      t.integer :subscribers_count
      t.integer :mods_count

      t.timestamps
    end

    add_index :guild_histories, :subscribers_count
    add_index :guild_histories, :mods_count
    add_index :guild_histories, :updated_at
    add_index :guild_histories, :created_at
  end
end
