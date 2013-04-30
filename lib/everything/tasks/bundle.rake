namespace :bundle do

  define_tasks_for_all_with_modules(:bundle, {
    'update' => Proc.new do |mod|
      begin
        Bundler.with_clean_env do
          system_with_prefix mod, "cd #{mod} && bundle update"
        end
      rescue => e
        puts e
      end
    end,

    'install' => Proc.new do |mod, args|
      begin
        Bundler.with_clean_env do
          system_with_prefix mod, "cd #{mod} && bundle install #{args.quiet}"
        end
      rescue => e
        puts e
      end
    end,

    'install_local' => Proc.new do |mod|
      begin
        Bundler.with_clean_env do
          system_with_prefix mod, "cd #{mod} && bundle install --local"
        end
      rescue => e
        puts e
      end
    end,

    'fast_install'  => Proc.new do |mod|
      begin
        Bundler.with_clean_env do
          output = `cd #{mod} && bundle install --local`
          unless $?.exitstatus == 0
            puts "[#{mod}:\tbundle install --local didn't work.  Installing missing project_gems".yellow
            output.each_line do | line |
              if /(?<gem>\S+)-(?<version>\S+) in any of the sources/ =~ line
                system "gem install #{gem} -v #{version}"
              end
            end
            system "cd #{mod} && bundle install --local"
            unless $?.exitstatus == 0
              system "cd #{mod} && bundle install"
            end
          end
        puts "[#{mod}:\tbundle install --local was successful!".green if $?.exitstatus == 0
        puts "[#{mod}:\tbundle install --local still failed!".red if $?.exitstatus != 0
        end
      rescue => e
        puts e
      end
    end,

    'package' => Proc.new do |mod|
      begin
        Bundler.with_clean_env do
          system_with_prefix mod, "cd #{mod} && bundle package"
        end
      rescue => e
        puts e
      end
    end,

    'remove_cached' => Proc.new do |mod|
      begin
        system_with_prefix mod, "cd #{mod}/vendor/cache && rm -f *"
      rescue => e
        puts e
      end
    end,
  })
end
