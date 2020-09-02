class AddIndexToGuildDataCreatedUtc < ActiveRecord::Migration[6.0]
  def up
    execute "CREATE INDEX index_guilds_on_created_utc ON guilds ((data->'created_utc'));"
  end

  def down
    execute "DROP INDEX IF EXISTS index_guilds_on_created_utc"
  end
end
