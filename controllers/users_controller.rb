class NewineServer < Sinatra::Application

	get  '/users.?:format?' do
		@users = User.all
		p 'Users index'
		p params[:format]
		format_render params[:format], :"users/index"
	end

	get '/users/tags/:uid.?:format?' do
		@tag = Tag.where(:uid => params[:uid]).first
		if @tag.nil?
			@user = User.new(:valid_user => false)
			@tag = Tag.new
		else
			@user = @tag.user
		end
		format_render params[:format], :"users/show"
	end

	get '/users/:id.?:format?' do
		@user = User.where(:id => params[:id]).first
		if @user.nil?
			@user = User.new(:valid_user => false)
			@tag = Tag.new
		else
			@tag = @user.tags.order('created_at desc').first
			@tag = Tag.new if @tag.nil?
		end
		format_render params[:format], :"users/show"
	end

	post '/users.?:format?' do
		@user = User.create(params[:user])
		if @user.valid?
			format_render params[:format], :"users/show"
		else
			#show_errors params[:format], :"users/new", :"users/show" 
		end
	end

end