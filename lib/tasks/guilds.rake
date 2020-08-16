namespace :guilds do
  desc "Updates the statistics of some Guilds"
  task update: :environment do
    # This task will update the top 1% Guilds (ordered by the formula subscribers_count + seconds since their last update) to update
    # them again, in other words guilds with more people and/or which have not been updated for a long time are prioritized to be updated

    guilds_ids = Guild.select('id, subscribers_count + EXTRACT(EPOCH FROM(current_timestamp - updated_at)) as points')
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
