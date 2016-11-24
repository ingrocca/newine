class NewineServer < Sinatra::Application
	
	get '/brands' do
		@q = Brand.ransack(params[:q])
		@brands = @q.result.paginate(:page=>params[:page], :per_page=>5)
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
		end
		redirect "/brands"
	end

	post '/brands/update/:id' do
		@brand = Brand.where(id: params[:id]).first
		if(@brand)
			@brand.update_attributes(params[:brand])
		end
		redirect "/brands/" + @brand.id.to_s
	end

	post "/brands/destroy/:id" do
		@brand = Brand.find(params[:id])
		@brand.destroy
		redirect "/brands"
	end
end