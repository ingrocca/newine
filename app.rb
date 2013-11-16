
require 'rubygems'
require 'sinatra/activerecord/rake'
require 'bundler/setup'

Bundler.require(:default)
require_all 'models'


set :database, "sqlite3:///db/newine.sqlite3"

class NewineServer < Sinatra::Application

	options = { :namespace => "newine", :compress => false }
	@@cache = Dalli::Client.new('localhost:11211', options)

	def self.cache
		@@cache
	end

	helpers do
		def format_render fmt, view
			case fmt
				when 'html', '', nil
					erb view
				when 'json'
					jbuilder view
				else
					p 'Unrecognized format'
			end
		end
		def show_errors fmt, html_route, json_route
			case fmt
				when 'html', '', nil
					erb html_route
				when 'json'
					jbuilder json_route
				else
					p 'Unrecognized format'
			end
		end
	end

	get '/' do
		erb :index
	end
end

require_all 'controllers'
