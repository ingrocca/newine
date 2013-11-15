class NewineServer < Sinatra::Application

	get '/events.json' do
		params[:since] = 1.year.ago if !params[:since]
		@events = Event.where('created_at > ?', params[:since]).order('created_at desc')
		@events = @events.where(:event_type => params[:types]) if params[:types]
		@events = @events.limit(100)

		jbuilder :"events/index"

	end

end