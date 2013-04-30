namespace :gem do
  task :dependencies do |t, args|
    include Everything::Project
    gem_dependencies = modules.inject({}) do |a, e|
      gemfile = File.readlines(File.join(File.dirname(__FILE__), "../#{e}/Gemfile"))
      gemfile = gemfile.map { |l| l.match(/gem\s+['"](.*?)['"]/)[1] rescue nil }.compact

      project_gemspec = File.readlines(File.join(File.dirname(__FILE__), "../#{e}/#{e}.project_gemspec")) rescue []
      project_gemspec = project_gemspec.map { |l| l.match(/add_(runtime|development)_dependency.*?['"](.*?)['"]/)[2] rescue nil }.compact

      all = (gemfile + project_gemspec)
      crap = all - modules
      deps = all - crap

      a.merge(e => deps)
    end

    gem_dependencies.each do |k, v|
      puts "#{k}: #{v.join ', '}"
    end
  end
end
