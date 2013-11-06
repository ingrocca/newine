
require 'rubygems'
require 'sinatra/activerecord/rake'
require 'bundler/setup'

Bundler.require(:default)
require_all 'models'


set :database, "sqlite3:///db/newine.sqlite3"

class NewineServer < Sinatra::Application
	helpers do
		def format_render fmt, view
			case fmt
				when 'hmtl', ''
					erb view
				when 'json'
					jbuilder view
			end
		end
		def show_errors fmt, html_route, json_route
			case fmt
				when 'hmtl', ''
					erb html_route
				when 'json'
					jbuilder json_route
			end
		end
	end

	get '/' do
		erb :index
	end
end

require_all 'controllers'
