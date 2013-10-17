require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)
require_all 'models'

set :database, "sqlite3:///db/newine.sqlite3"

