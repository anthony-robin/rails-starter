set :output, error: "#{path}/log/error.log", standard: "#{path}/log/cron.log"

every 1.day, at: '4:00 am' do
  rake '-s sitemap:refresh'
  rake 'db:backup MAX=5'
end
