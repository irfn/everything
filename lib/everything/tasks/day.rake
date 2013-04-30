#encoding: utf-8

desc 'get and be on the latest code'
task :latest_code do
  puts "pulling latest 'everything'...".green
  `git pull --rebase`
  %w{
    utf8_check
    git:clone
    git:rebase
  }.each {|t| Rake::Task[t].invoke }
end

GIT_ALREADY_UP_TO_DATE_MESSAGES = ['Current branch master is up to date.', 'Already up-to-date']

desc 'get and be on the latest code'
task :morning do
  require 'git'
  include Everything::Project
  current_folder = '.'
  ([current_folder] + modules).each do |mod|
    print "Updating #{mod}… "

    begin
      git = Git.open(mod)
      git_pull_response = git.pull(nil, nil, '--rebase')

      if git_pull_response =~ Regexp.new(GIT_ALREADY_UP_TO_DATE_MESSAGES.join('|'))
        puts '√'.green
      else
        puts "\n#{git_pull_response.yellow}"

        Rake::Task["bundle:install:#{mod}"].invoke('--quiet')
        Rake::Task["restart:#{mod}"].invoke if project_apps.include? mod
      end
    rescue Exception => ex
      puts "\n#{ex.to_s.red}"
    end
  end
end
