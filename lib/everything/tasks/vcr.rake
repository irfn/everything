namespace :vcr do
  define_tasks_for_all_with_modules(:vcr, {
    'wipe' => Proc.new do |mod|
      cassettes = File.join(mod, 'spec', 'cassettes')
      if File.exists? cassettes
        FileUtils.rm_rf cassettes
      else
        puts "#{cassettes} doesn't exist. Skipping."
      end
    end,

    'recreate' => Proc.new do |mod|
      cassettes = File.join(mod, 'spec', 'cassettes')
      if File.exists? cassettes
        Rake::Task['run:all'].invoke
        Rake::Task["vcr:wipe:#{mod}"].invoke
        Bundler.with_clean_env do
          sh "cd #{mod} && bundle && rake"
        end
        Rake::Task['stop:all'].invoke
      else
        puts "#{mod}/spec/cassettes doesn't exist. Skipping"
      end
    end,
  })
end
