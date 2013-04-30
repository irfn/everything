require "everything/version"
require 'settingslogic'
require 'colorize'

module Everything
  class Config <  ::Settingslogic
    source "#{File.dirname(ENV['BUNDLE_GEMFILE'])}/everything.yml"
  end
end

require 'everything/project'
require 'everything/rackup_server'

load "#{File.dirname(__FILE__)}/everything/tasks/git.rake"
load "#{File.dirname(__FILE__)}/everything/tasks/bundle.rake"
load "#{File.dirname(__FILE__)}/everything/tasks/cloc.rake"
load "#{File.dirname(__FILE__)}/everything/tasks/ctags.rake"
load "#{File.dirname(__FILE__)}/everything/tasks/server.rake"
load "#{File.dirname(__FILE__)}/everything/tasks/tail.rake"
load "#{File.dirname(__FILE__)}/everything/tasks/vcr.rake"
load "#{File.dirname(__FILE__)}/everything/tasks/launch.rake"
load "#{File.dirname(__FILE__)}/everything/tasks/foreach.rake"
load "#{File.dirname(__FILE__)}/everything/tasks/dependencies.rake"
load "#{File.dirname(__FILE__)}/everything/tasks/day.rake"