class NewineServer < Sinatra::Application

	get  '/dispensers.json' do
		@dispensers = Dispenser.all
		jbuilder :"dispensers/index"
	end

	get '/dispensers/uid/:uid.?:format?' do
		@dispenser = Dispenser.where(:uid => params[:uid]).first
		if @dispenser.nil?
			raise Sinatra::NotFound
		end
		format_render params[:format], :"dispensers/show"
	end

	get '/dispensers/id/:id.?:format?' do
		@dispenser = Dispenser.where(:id => params[:id]).first
		if @dispenser.nil?
			raise Sinatra::NotFound
		end
		format_render params[:format], :"dispensers/show"
	end

	post '/dispensers.?:format?' do
		@dispenser = Dispenser.create(params[:dispenser])
		if @dispenser.valid?
			format_render params[:format], :"dispensers/show"
		else
			show_errors params[:format], :"dispensers/new", :"dispensers/show" 
		end
	end

end