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
		p 'created dispenser'
		if @dispenser.valid?
			Event.log(
				"Nuevo Dispenser",
				"ID: " + @dispenser.id.to_s + ", Nro. de Serie: " + @dispenser.uid.to_s + ".",
				"/dispensers/id/" + @dispenser.id.to_s,
				0x111111,
				"new_dispenser")

			p 'dispenser ' + @dispenser.id.to_s
			redirect to('/dispensers/id/' + @dispenser.id.to_s)
		else
			show_errors params[:format], :"dispensers/new", :"dispensers/show" 
		end
	end

	delete '/dispensers/:id' do
		@dispenser = Dispenser.find(params[:id])
		@dispenser.destroy
		halt 204
	end

end