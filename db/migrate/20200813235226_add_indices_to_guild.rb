class AddIndicesToGuild < ActiveRecord::Migration[6.0]
  def up
    execute "CREATE INDEX index_guilds_on_over_18 ON guilds ((data->'over_18'));"
    execute "CREATE INDEX index_guilds_on_is_banned ON guilds ((data->'is_banned'));"
    execute "CREATE INDEX index_guilds_on_is_private ON guilds ((data->'is_private'));"
    execute "CREATE INDEX index_guilds_on_is_restricted ON guilds ((data->'is_restricted'));"
  end

  def down
    execute "DROP INDEX IF EXISTS index_guilds_on_over_18"
    execute "DROP INDEX IF EXISTS index_guilds_on_is_banned"
    execute "DROP INDEX IF EXISTS index_guilds_on_is_private"
    execute "DROP INDEX IF EXISTS index_guilds_on_is_restricted"
  end
end
