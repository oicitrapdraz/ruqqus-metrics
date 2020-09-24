class AddGinIndexToGuildDataDescription < ActiveRecord::Migration[6.0]
  def up
    execute "CREATE INDEX index_guilds_on_data ON guilds USING gin ((data::text) gin_trgm_ops);"
  end

  def down
    execute 'DROP INDEX IF EXISTS index_guilds_on_data'
  end
end
