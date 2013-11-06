class NewineServer < Sinatra::Application

	get  '/users.:format' do
		@users = User.all
		format_render params[:format], :"users/index"
	end

	get '/users/:uid.:format' do
		@user = User.where(:uid => params[:uid]).first
		raise Sinatra::NotFound if !@user
		format_render params[:format], :"users/show"
	end

	post '/users.:format' do
		@user = User.create(params[:user])
		if @user.valid?
			format_render params[:format], :"users/show"
		else
			#show_errors params[:format], :"users/new", :"users/show" 
		end
	end

end