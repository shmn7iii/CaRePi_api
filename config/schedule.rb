set :output, 'log/crontab.log'
ENV.each { |k, v| env(k, v) }
set :environment, :development

every '0 15 * * *' do
  rake 'carepi:leaveall'
end
