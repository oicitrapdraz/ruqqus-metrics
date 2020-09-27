namespace :guilds do
  desc "Updates the statistics of some Guilds"
  task update: :environment do
    # This task will update the top 0.5% Guilds (ordered by the formula subscribers_count + seconds since their last update) to update
    # them again, in other words guilds with more people and/or which have not been updated for a long time are prioritized, but it
    # also avoid to update the same guild more than once every 12 hours

    number_of_guilds_to_update = Guild.count / 200

    guilds_ids = Guild.where
                      .not("data->>'is_banned' = ?", 'true')
                      .or(Guild.where(data: nil))
                      .where('updated_at < ?', 12.hours.ago)
                      .select('id, subscribers_count + EXTRACT(EPOCH FROM(CURRENT_TIMESTAMP - updated_at)) + CASE WHEN week_growth IS NULL THEN 0 ELSE week_growth END as points')
                      .order(points: :desc)
                      .limit(number_of_guilds_to_update)
                      .map(&:id)

    guilds_ids.each do |guild_id|
      guild = Guild.find(guild_id)

      API::Importer::Guild.new(guild).call
    end
  end

  desc "Create new Guilds from Ruqqus"
  task create: :environment do
    API::Importer::Guilds.new.call
  end

  desc "Clean Guilds History"
  task clean: :environment do
    GuildHistory.where('created_at < ?', 3.months.ago).delete_all
  end
end
