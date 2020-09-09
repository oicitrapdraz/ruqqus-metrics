namespace :guilds do
  desc "Updates the statistics of some Guilds"
  task update: :environment do
    # This task will update the top 2% Guilds (ordered by the formula subscribers_count + seconds since their last update) to update
    # them again, in other words guilds with more people and/or which have not been updated for a long time are prioritized, but it
    # also avoid to update the same guild more than once every 12 hours

    number_of_guilds_to_update = Guild.count * 2 / 100

    guilds_ids = Guild.where
                      .not("data->>'is_banned' = ?", 'true')
                      .or(Guild.where(data: nil))
                      .where('updated_at < ?', 12.hours.ago)
                      .select('id, subscribers_count + EXTRACT(EPOCH FROM(current_timestamp - updated_at)) as points')
                      .order(points: :desc)
                      .limit(number_of_guilds_to_update)
                      .map(&:id)

    guilds_ids.each do |guild_id|
      guild = Guild.find(guild_id)

      API::Importer::Guild.new(guild).call
    end
  end

  desc "Scrape Guilds in Ruqqus"
  task scrape: :environment do
    Scraper::Guild.new.call
  end

  desc "Clean Guilds History"
  task clean: :environment do
    GuildHistory.where('created_at < ?', 3.months.ago).delete_all
  end
end
