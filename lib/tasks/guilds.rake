namespace :guilds do
  desc "Updates the statistics of some guilds"
  task update: :environment do
    guilds_ids = Guild.select('id, subscribers_count + EXTRACT(EPOCH FROM(current_timestamp - created_at)) / 60 as points')
                  .order(points: :desc)
                  .limit(Guild.count / 100)
                  .map(&:id)

    guilds_ids.each { |guild_id| API::Importer::Guild.new(Guild.find(guild_id)).call }
  end

  desc "TODO"
  task scrape: :environment do
  end
end
