class RackupServer
  include Everything::Project
  def initialize(app)
    @app = app
    @port = project_apps[app]
  end

  def start
    pid_file = File.expand_path("#{@app}/#{@app}.#{@port}.pid")

    if process_alive? pid_file
      puts "#{@app} is already running on port #{@port}".cyan
    else
      puts "#{@app} is not running, starting it...".yellow
      Bundler.with_clean_env do
        system_with_prefix @app, [
          "cd #{@app}",
          "bundle exec rackup -D -P #{pid_file} -p #{@port}",
        ].join(' && ')

        sleep 3
        system_with_prefix @app, "cd #{@app} && cat log/#{@app}.log" unless process_alive? pid_file
      end
    end
  end

  def stop
    pid_file = "#{@app}/#{@app}.#{@port}.pid"

    system_with_prefix @app, "test -f #{pid_file} && kill -9 `cat #{pid_file}`"
  end

  def restart
    pid_file = "#{@app}/#{@app}.#{@port}.pid"
    Rake::Task["stop:#{@app}"].invoke @port
    while  process_alive? pid_file
      sleep(1)
    end
    Rake::Task["run:#{@app}"].invoke @port
  end
end
