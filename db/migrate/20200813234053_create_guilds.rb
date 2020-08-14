class CreateGuilds < ActiveRecord::Migration[6.0]
  def change
    create_table :guilds do |t|
      t.string :name
      t.jsonb :data
      t.integer :subscribers_count
      t.integer :mods_count

      t.timestamps
    end

    add_index :guilds, :subscribers_count
    add_index :guilds, :mods_count
    add_index :guilds, :updated_at
    add_index :guilds, :created_at
  end
end
