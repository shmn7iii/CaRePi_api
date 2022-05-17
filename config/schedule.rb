set :output, 'log/crontab.log'
set :environment, ENV['RAILS_ENV']

every '0 0 * * *' do
  rake 'carepi:leaveall'
end
