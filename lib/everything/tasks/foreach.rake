namespace :foreach do
  desc "run a command on all the repos"
  task :all do
    include Everything::Project
    ARGV.shift # throw away 'foreach'
    for_each modules, ARGV.join(' ')
    exit
  end

  desc "run a command on all the gem repos"
  task :project_gems do
    include Everything::Project
    ARGV.shift # throw away 'foreach'
    for_each project_gems, ARGV.join(' ')
    exit
  end

  desc "run a command on all the app repos"
  task :project_apps do
    include Everything::Project
    ARGV.shift # throw away 'foreach'
    for_each project_apps, ARGV.join(' ')
    exit
  end

  def for_each types, command
    types.each do |mod|
      Bundler.with_clean_env do
        system_with_prefix mod, "cd #{mod} ; #{command}"
      end
    end
  end
end

desc "run a command on all the repos"
task :foreach => :'foreach:all'