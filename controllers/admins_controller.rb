class NewineServer < Sinatra::Application

	get  '/admins.?:format?' do
		@admins = Admin.all
		p 'Admins index'
		p params[:format]
		format_render params[:format], :"admins/index"
	end


	get '/admins/:id.?:format?' do
		@admin = Admin.where(:id => params[:id]).first
		if @admin.nil?
			@admin = Admin.new(:valid_admin => false)
		end
		format_render params[:format], :"admins/show"
	end

	post '/admins.?:format?' do
		@admin = Admin.create(params[:admin])
		if @admin.valid?
			format_render params[:format], :"admins/show"
		else
			#show_errors params[:format], :"admins/new", :"admins/show" 
		end
	end

	post '/admins/login.?format?' do
		session[:admin] = Admin.authenticate(params[:username], params[:password])
		if session[:admin]
			redirect to('/')
		else
			halt 401
		end
	end
end