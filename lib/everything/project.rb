module Everything
  module Project
    def project_gems
      ::Everything::Config.gems rescue []
    end

    def project_apps
      ::Everything::Config.apps rescue {}
    end

    def project_other
      ::Everything::Config.other rescue []
    end

    def modules
      project_apps.keys + project_gems + project_other
    end

    def max_module_name_size
      modules.map(&:size).max
    end

    def process_alive?(pid_file)
      begin
        File.exists?(pid_file) && Process.kill(0, IO.read(pid_file).to_i)
      rescue Errno::ESRCH
        false
      end
    end

    def define_tasks_for_all_with_modules(namespace, commands)
      define_tasks_for_set(modules, namespace, commands)
    end

    def define_tasks_for_all_with_project_gems(namespace, commands)
      define_tasks_for_set(project_gems, namespace, commands)
    end

    def define_tasks_for_set(module_set, namespace, commands)
      commands.each do |name, command|
        human_name = name.gsub(/_/, ' ').capitalize

        desc "#{human_name} for a specific repository"
        task name, :repository do |t, args|
          if args.repository
            Rake::Task["#{namespace}:#{name}:#{args.repository}"].invoke
          else
            Rake::Task["#{namespace}:#{name}:all"].invoke
          end
        end

        namespace name do
          desc "#{human_name} for all repositories"
          task :all do
            module_set.each do |mod, args|
              Rake.application.invoke_task("#{namespace}:#{name}:#{mod}")
            end
          end

          module_set.each do |mod|
            task mod, [:quiet] do |_, args|
              command.call mod, args
            end
          end
        end
      end
    end

    def system_with_prefix(prefix, command)
      system "#{command} 2>&1| awk '{printf \"%-#{max_module_name_size + 1}s %s\\n\", \"\033[1;34m\" \"#{prefix}:\",  $0 \"\033[0m\"}'"
    end
  end
end