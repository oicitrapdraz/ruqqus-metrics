class AddGinIndexToGuildName < ActiveRecord::Migration[6.0]
  def up
    execute 'CREATE INDEX index_guilds_on_name ON guilds USING gin (name gin_trgm_ops);'
  end

  def down
    execute 'DROP INDEX IF EXISTS index_guilds_on_name'
  end
end
