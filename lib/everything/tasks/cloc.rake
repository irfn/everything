desc 'Generates report on # of lines of production code'
task :cloc do
  include Everything::Project
  modules.each do |mod|
    Bundler.with_clean_env do
      options_file = "#{mod}/.clocrc"

      unless File.exists? options_file
        puts "#{options_file} doesn't exist. Skipping..."
        next
      end

      options = File.read(options_file).gsub("\n", '').strip
      system_with_prefix mod, "cd #{mod} ; cloc . --quiet --out=../#{mod}.clocreport #{options}"
    end
  end
end
