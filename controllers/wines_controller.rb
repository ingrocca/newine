class NewineServer < Sinatra::Application

	get '/wines.?:format?' do
		@wines = Wine.all
		format_render params[:format], :"wines/index"
	end

	get '/wines/:id.?:format?' do
		@wine = Wine.where(:id => params[:id]).first
		if @wine.nil?
			raise Sinatra::NotFound
		end
		format_render params[:format], :"wines/show"
	end

	post '/wines' do
		@wine = Wine.create(params[:wine])
		p 'created wine'
		if @wine.valid?
			Event.log(
				"Nuevo Vino",
				@wine.name + ", " + @wine.variety + " " + @wine.vintage.to_s,
				"/wines/" + @wine.id.to_s,
				0xA88,
				"new_wine")
			redirect to('/wines/' + @wine.id.to_s)
		else
			redirect to('/wines')
		end
	end
end