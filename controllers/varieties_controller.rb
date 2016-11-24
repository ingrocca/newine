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

	post "/variety.?:format?" do
		@variety = Variety.create(params[:variety])
		redirect to('/varieties/' + @variety.id.to_s)
	end

	post '/varieties/update/:id' do
		@variety = Variety.where(:id => params[:id]).first
		if(@variety)
			@variety.update_attributes(params[:variety])
		end
		redirect to('/varieties/' + @variety.id.to_s)
	end
end