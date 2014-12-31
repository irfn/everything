include Everything::Project

def server(app)
  RackupServer.new app
end

namespace :run do
  project_apps.each_key do |app|
    desc "Start the #{app} application (default port: #{project_apps[app]})"
    task app do
      server(app).start
    end
  end

  task :all do
    threads = []
    project_apps.each_key do |app|
      threads << Thread.new { Rake::Task["run:#{app}"].invoke }
    end
    threads.each do |thread|
      thread.join
    end
  end

end

desc "Start all applications in their default project_project_gems(#{project_apps.keys.join ', '})"
task :run => :'run:all'

task :start => :run

namespace :stop do
  project_apps.each_key do |app|
    desc "Stop the #{app} application (default port: #{project_apps[app]})"
    task app do
      server(app).stop
    end
  end

  task :all do
    threads = []
    project_apps.each_key do |app|
      threads << Thread.new { Rake::Task["stop:#{app}"].invoke }
    end
    threads.each do |thread|
      thread.join
    end
  end
end

desc "Stop all applications in their default project_project_gems(#{project_apps.keys.join ', '})"
task :stop => :'stop:all'

namespace :restart do
  project_apps.each_key do |app|
    desc "Restart the #{app} application (default port: #{project_apps[app]})"
    task app do
      server(app).restart
    end
  end

  task :all do
    threads = []
    project_apps.each_key do |app|
      threads << Thread.new { Rake::Task["restart:#{app}"].invoke }
    end

    threads.each do |thread|
      thread.join
    end
  end
end

desc "Restart all applications in their default project_project_gems(#{project_apps.keys.join ', '})"
task :restart => :"restart:all"
