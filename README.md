# Everything

Everything gem allows creation of a wrapper project composed of multiple ruby project that are in seperate git repositories, allowing to work with them in tandem. The projects are specified in an *everything.yml* and based on the configuration, the everything gem provides rake tasks for

- git operations like update all, rebase all etc.
- bundle install all, update:all etc.
- ctags
- running, restarting rack apps on ports specified, stop all, start all etc.




## Installation

Add this line to your application's Gemfile:

    gem 'everything'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install everything

## Usage

Example project setup.

    mkdir project-name


*Gemfile*

    source 'https://rubygems.org'

    gem 'rake'
    gem 'everything', git: 'https://github.com/irfn/everything.git'
    

*Rakefile*

    require 'bundler/setup'
	require 'everything'
	
	
*everything.yml*

    git:
      git@github.com:organization_name
    gems:
      - ci_tasks
    apps:
      service_2:
        3001
      service_1:
        4001
      webapp_1:
        5001
        

*.gitignore*

    .bundle
    tags
    .idea/*
    *.swp*
    *.clocreport
    .yardoc
    service_1
    service_2
    webapp_1


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
