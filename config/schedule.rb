# Use this file to easily define all of your cron jobs.
# Learn more: http://github.com/javan/whenever

# uncomment the line below if you wish to use zsh for cron jobs for rudika
# set :job_template, "/usr/bin/zsh -l -c ':job'"

job_type :record, 'cd :path && bundle exec ./rudika rec -s :task'
