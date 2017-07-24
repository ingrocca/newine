class NewineServer < Sinatra::Application
	
	get '/brands' do
		@q = Brand.ransack(params[:q])
		@brands = @q.result.order(:name).paginate(:page=>params[:page], :per_page=>5)
		format_render 'html', :"brands/index"
	end
	
	get '/brands/:id' do
		@q = Brand.ransack({id_eq: params[:id]})
		@brands = @q.result.paginate(:page=>params[:page], :per_page=>5)
		format_render 'html', :"brands/index"
	end

	post '/brands/save' do
		@brand = Brand.new(params[:brand])
		if(@brand.save)
			redirect "/brands/" + @brand.id.to_s
		else
			flash[:error] = "Ocurrió un error creando la bodega #{@brand.errors.messages}"
			redirect "/brands"
		end
	end

	post '/brands' do
		@brand = Brand.new(params[:brand])
		if(@brand.save)
			content_type :json
			@brand.to_json
		end
	end

	post '/brands/update/:id' do
		@brand = Brand.where(id: params[:id]).first
		if( !@brand.update_attributes(params[:brand]) )
			flash[:error] = "Ocurrió un error actualizando la bodega #{@brand.errors.messages}"
		end
		redirect "/brands/" + @brand.id.to_s
	end

	post "/brands/destroy/:id" do
		@brand = Brand.find(params[:id])
		@brand.destroy
		redirect "/brands"
	end
end
