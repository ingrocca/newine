require 'rubygems'
require 'sinatra/activerecord/rake'
require 'bundler/setup'
require 'sinatra/flash'

Bundler.require(:default)
require 'will_paginate'
require 'will_paginate/active_record'

require_all 'models'

set :database, {adapter: "sqlite3", database: "../data/newine.sqlite3"}

class NewineServer < Sinatra::Application
  # Satisfies assumption number 1 above.
  use Rack::Session::Cookie

  # Mixes `Shield::Helpers` into your routes context.
  helpers Shield::Helpers
  
  register Sinatra::Flash

  options = { :namespace => "newine", :compress => false }
  @@cache = Dalli::Client.new('localhost:11211', options)
  def self.cache
    @@cache
  end

  configure do
    set :threaded,false
  end

  helpers do
    def format_float(value)
      '%.2f' % value.round(2)
    end

    def format_render(fmt, view)
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

    def boolean_humanize boolean
      case boolean
      when true
        "Si"
      else
        'No'
      end
    end

    def percentage_humanize percentage
      percentage * 100
    end

    def current_user
      @current_user ||= authenticated(Admin)
    end

    def selected_user(user_id)
      User.find(user_id)
    end

    def selected_brand(brand_id)
      Brand.find(brand_id)
    end

    def selected_wine(wine_id)
      Wine.find(wine_id)
    end
  end
  
  get '/' do
    erb :index
  end

  get '/download' do
    send_file "../data/newine.sqlite3", type: "sqlite3", disposition: 'attachment', filename: "newine.sqlite3"
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
          $channel.push({:tag=>{:uid=> uid}}.to_json)
          NewineServer.cache.set('nfc_uid',nil)
        else
          sleep(0.1)
        end
      end
    end

    NewineServer.run!(:bind=>'0.0.0.0',:port =>3000)
  end
end
