namespace :git do
  include Everything::Project
  define_tasks_for_all_with_modules(:git, {
      'clone'  => Proc.new do |mod|
        raise 'Please specify a repository to clone (or run git:clone:all)' unless mod

        if File.exists? mod
          puts "#{mod} already exists. Skipping.".cyan
        else
          system_with_prefix mod, "git clone #{Everything::Config.git}/#{mod}.git"
        end
      end,

      'pull'   => Proc.new do |mod|
        system_with_prefix mod, "cd #{mod} && git pull origin master"
      end,

      'push'   => Proc.new do |mod|
        system_with_prefix mod, "cd #{mod} && git push"
      end,

      'rebase' => Proc.new do |mod|
        system_with_prefix mod, "cd #{mod} && git pull --rebase "
      end,

      'fetch'  => Proc.new do |mod|
        system_with_prefix mod, "cd #{mod} && git fetch"
      end,

      'status' => Proc.new do |mod|
        system_with_prefix mod, "cd #{mod} && git status"
      end,

      'st'     => Proc.new do |mod|
        system_with_prefix mod, "cd #{mod} && git status --short | grep -v '^#'"
      end,

      'co'     => Proc.new do |mod|
        system_with_prefix mod, "cd #{mod} && git checkout"
      end,

      'reset'  => Proc.new do |mod|
        system_with_prefix mod, "cd #{mod} && git reset --hard"
      end
  })
end
