class NewineServer < Sinatra::Application

	get  '/users.?:format?' do
		if params[:q]
			@users = User.where('name like ? or surname like ? or dni like ? or email like ?','%' + params[:q] + '%','%' + params[:q] + '%','%' + params[:q] + '%','%' + params[:q] + '%').
			paginate(:page=>params[:page], :per_page=>5)
		else
			@users = User.paginate(:page=>params[:page], :per_page=>5)
		end
		format_render params[:format], :"users/index"
	end

	get '/users/tags/:uid.json' do
		@tag = Tag.where(:uid => params[:uid]).first
		if(params[:dispenser_id])
			@dispenser = Dispenser.where(id: params[:dispenser_id]).first
		end
		puts 'UID: ' + params[:uid]
		if @tag.nil? || !@tag.active
			@user = User.new(:valid_user => false)
			@tag = Tag.new
		else
			@user = @tag.user
		end
		format_render 'json', :"users/show"
	end

	get '/users/tags/:uid' do
		@users = User.joins(:tags).where('tags.uid = ?', params[:uid]).paginate(:page=>params[:page], :per_page=>5)
		format_render 'html', :"users/index"
	end

	post '/users/:id/tags/create' do
		@user = User.where(:id => params[:id]).first
		@tag = Tag.new(params[:tag].merge(user: @user))
		@user.add_tag(@tag)
		TagMovement.create(tag_id: @tag.id, credit: @tag.credit)
		redirect '/users'
	end

	get '/users/:id.json' do
		@user = User.where(:id => params[:id]).first
		if @user.nil?
			@user = User.new(:valid_user => false)
			@tag = Tag.new
		else
			@tag = @user.tags.order('created_at desc').first
			@tag = Tag.new if @tag.nil?
		end
		format_render 'json', :"users/show"
	end
	get '/users/:id' do
		@users = User.where(:id => params[:id]).paginate(:page=>params[:page], :per_page=>5)
		format_render 'html', :"users/index"
	end

	post '/users.?:format?' do
		params[:user][:valid_user]=true
		@user = User.create(params[:user])
		if @user.valid?
			@user.valid_user = true
			@user.save
			#format_render params[:format], :"users/show"
			redirect "users/#{@user.id}"
		else
			redirect "users/index"
			#show_errors params[:format], :"users/new", :"users/show" 
		end
	end

	post '/users/edit/:id' do
		@users = User.where(:id => params[:id]).paginate(:page=>params[:page], :per_page=>5)
		@user = @users.first
		if(@user)
			@user.update_attributes(params[:user])
		end
		format_render 'html', :"users/index"
	end

	post '/users/destroy/:id' do
		@user = User.find(params[:id])
		@user.destroy
		redirect "/users"
	end
end
