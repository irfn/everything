namespace :launch do
  include Everything::Project
  project_apps.each do |app, default_port|
    desc "Launch the #{app} in your default browser"
    task app, :port do |t, args|
      port = args[:port] || default_port

      case RUBY_PLATFORM
      when /darwin/
        system_with_prefix app, "open 'http://localhost:#{port}'"
      when /linux/
        system_with_prefix app, "xdg-open 'http://localhost:#{port}'"
      else
        raise 'Your OS is not supported. Sorry! :)'
      end
    end
  end
end
