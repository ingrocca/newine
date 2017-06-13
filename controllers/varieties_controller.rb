class NewineServer < Sinatra::Application
	
	get '/varieties' do
		@q = Variety.ransack(params[:q])
		@varieties = @q.result.paginate(:page=>params[:page], :per_page=>5)

		format_render 'html', :"varieties/index"
	end

	get '/varieties/:id' do
		@q = Variety.ransack({id_eq: params[:id]})
		@varieties = @q.result.paginate(:page=>params[:page], :per_page=>5)
		format_render 'html', :"varieties/index"
	end

	post "/variety" do
		@variety = Variety.new(params[:variety])
		if(@variety.save)
			redirect to('/varieties/' + @variety.id.to_s)
		else
			flash[:error] = "Ocurrió un error creando la variedad #{@variety.errors.messages}"
			redirect "/varieties"
		end
	end

	post '/variety.json' do
		@variety = Variety.new(params[:variety])
		if(@variety.save)
			content_type :json
			@variety.to_json
		end
	end

	post '/varieties/update/:id' do
		@variety = Variety.where(:id => params[:id]).first
		if( ! @variety.update_attributes(params[:variety]) )
			flash[:error] = "Ocurrió un error actualizando la variedad #{@variety.errors.messages}"
		end
		redirect to('/varieties/' + @variety.id.to_s)
	end
end
