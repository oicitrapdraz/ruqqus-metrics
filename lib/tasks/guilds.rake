namespace :guilds do
  desc "Updates the statistics of some Guilds"
  task update: :environment do
    guilds_ids = Guild.select('id, subscribers_count + EXTRACT(EPOCH FROM(current_timestamp - created_at)) / 60 as points')
                  .order(points: :desc)
                  .limit(Guild.count / 100)
                  .map(&:id)

    guilds_ids.each { |guild_id| API::Importer::Guild.new(Guild.find(guild_id)).call }
  end

  desc "Scrape Guilds in Ruqqus"
  task scrape: :environment do
    Scraper::Guild.new.call
  end
end
