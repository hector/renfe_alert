# Use this file to easily define all of your cron jobs.
# Learn more: http://github.com/javan/whenever

every 1.hour do
  command "cd #{Dir.pwd} && bundle exec ./renfe_alert.rb"
end
