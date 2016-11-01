class NewineServer < Sinatra::Application
	
	get '/categories' do
		@q = Category.ransack(params[:q])
		@categories = @q.result.paginate(:page=>params[:page], :per_page=>5)
		format_render 'html', :"categories/index"
	end
	
	get '/categories/:id' do
		@q = Category.ransack(:id => params[:id])
		@categories = @q.result.paginate(:page=>params[:page], :per_page=>5)
		format_render 'html', :"categories/index"
	end


	post '/categories/save' do
		@category = Category.new(params[:category])
		if(@category.save)
			redirect "/categories/#{@category.id}"
		end
		redirect "/categories"
	end

	post '/categories/update/:id' do
		@category = Category.where(id: params[:id]).first
		if(@category)
			@category.update_attributes(params[:category])
		end
		redirect "/categories"
	end

	post "/categories/destroy/:id" do
		@category = Category.find(params[:id])
		@category.destroy
		redirect "/categories"
	end
end