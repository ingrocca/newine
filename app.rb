
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

	#get '/nfc' do
	#	uid =  @@cache.get('nfc_uid')
	#	if uid
	#		@@cache.set('nfc_uid',nil)
	#		return uid.to_s
	#	else
	#		return "Nothing"
	#	end
	#end

	get '/' do
		erb :index
	end
end

require_all 'controllers'

def run_newine
	EM.run do
		$channel = EM::Channel.new
	 
		EventMachine::WebSocket.start(:host => '0.0.0.0', :port => 8080) do |ws|
			ws.onopen {
				sid = $channel.subscribe { |msg| ws.send msg }

				ws.onmessage { |msg|
					#@channel.push "<#{sid}>: #{msg}"
				}

				ws.onclose {
					$channel.unsubscribe(sid)
				}
			}

		end

		nfc_notifier = Thread.new do
			loop do
				uid =  NewineServer.cache.get('nfc_uid')
				if(uid)
					$channel.push uid
					NewineServer.cache.set('nfc_uid',nil)
				else
					sleep(0.1)
				end
			end
		end

		NewineServer.run!(:bind=>'0.0.0.0',:port =>3000)
	end
end