class NewineServer < Sinatra::Application

	get  '/servings.json' do
		@servings = Serving.all
		jbuilder :"servings/index"
	end

	get '/servings/:id.?:format?' do
		@serving = Serving.where(:id => params[:id]).first
		if @serving.nil?
			raise Sinatra::NotFound
		end
		format_render params[:format], :"servings/show"
	end

	post '/servings' do
		@serving = Serving.create(params[:serving])
		p 'created serving'
		if @serving.valid?

			@serving.bottle_holder = 
			@serving.wine_id = @serving.bottle_holder

			Event.log(
				"Nuevo Serving",
				"ID: " + @serving.id.to_s + ", Nro. de Serie: " + @serving.uid.to_s + ".",
				"/servings/id/" + @serving.id.to_s,
				0x119933,
				"new_serving")
			
		else
			erb :index
		end
	end

	delete '/servings/:id' do
		@serving = Serving.find(params[:id])
		@serving.destroy
		halt 204
	end

end