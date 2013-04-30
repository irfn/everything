desc '(Re)generate a Vim-compatible tags file'
task :ctags do
  include Everything::Project
  sh 'rm -rf tags ; ctags -R'
  modules.each do |mod|
    Bundler.with_clean_env do
      system_with_prefix mod, "cd #{mod} ; rm -rf tags ; ctags -R"
    end
  end
end
