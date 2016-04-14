class NewineServer < Sinatra::Application

	get '/categories' do
		if params[:q]
			@categories = Category.where("name LIKE :query", query: "%#{params[:q]}%").paginate(:page=>params[:page], :per_page=>5)
		else
			@categories = Category.paginate(:page=>params[:page], :per_page=>5)
		end
		format_render 'html', :"categories/index"
	end

	get '/categories/:id' do
		@categories = Category.where(:id => params[:id]).paginate(:page=>params[:page], :per_page=>5)
		format_render 'html', :"categories/index"
	end

	post '/category/save' do
		@category = Category.new(params[:category])
		if(@category.save)
			redirect "/categories/#{@category.id}"
		end
		redirect "/categories"
	end

	post '/category/update/:id' do
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