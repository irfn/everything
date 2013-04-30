namespace :tail do
  include Everything::Project
  project_apps.each do |app, default_port|
    desc "tail the #{app} application logs"
    task app do |t, args|
      system_with_prefix app, "cd #{app} && tail -f log/*.log &"
    end
  end

  task :all do
    include Everything::Project
    project_apps.map do |app, port|
      Rake::Task["tail:#{app}"].invoke port
    end
    `tail -f /dev/null` # ugh…
  end
end

desc 'Tail all application logs'
task :tail => :'tail:all'
