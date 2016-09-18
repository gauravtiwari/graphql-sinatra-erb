# Load path and gems/bundler
$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

require 'bundler'
require 'tilt/erb'
require 'logger'
require 'colorize'
require 'sass/plugin/rack'
require 'turbolinks/source'
require 'graphql/client'
require 'graphql/client/http'
Bundler.require

# Local config
require 'find'

# Load environment
require 'dotenv'
Dotenv.load

# Load initializers
%w{config/initializers}.each do |load_path|
  Find.find(load_path) { |f|
    require f unless f.match(/\/\..+$/) || File.directory?(f)
  }
end

# Load app
require "sinatra_graphql_erb"
run SinatraGraphqlErb
