#coding: utf-8
class NewineServer < Sinatra::Application

	get  '/tags.json' do
		@tags = Tag.all
		jbuilder :"tags/index"
	end

	get '/tags/uid/:uid.?:format?' do
		@tag = Tag.where(:uid => params[:uid]).first
		if @tag.nil?
			raise Sinatra::NotFound
		end
		format_render params[:format], :"tags/show"
	end

	get '/tags/id/:id.?:format?' do
		@tag = Tag.where(:id => params[:id]).first
		if @tag.nil?
			raise Sinatra::NotFound
		end
		format_render params[:format], :"tags/show"
	end

	put '/tags/:id' do
		@tag = Tag.where(:id => params[:id]).first
		if @tag.nil?
			raise Sinatra::NotFound
		end

		if @tag.update_attributes(params[:tag])
			Event.log(
				"Tag actualizado",
				"ID: " + @tag.id.to_s + ", Nro. de Serie: " + @tag.uid.to_s + ".",
				"/tags/id/" + @tag.id.to_s,
				0xEEE,
				"updated_tag")
			if @tag.user
				redirect to('/users/id/' + @tag.user.id.to_s)
			else
				redirect to('/')
			end
		else
			Event.log(
				"Tag no se pudo guardar",
				@tag.errors.full_messages.join(', '),
				"/",
				0xE33,
				"errors")
			redirect to('/')
		end

	end

	post '/tags' do
		p params.to_json
		if params[:new_user] == 'true' || params[:new_user] === true
			params[:user][:valid_user]=true
			@user = User.create(params[:user])
			if @user.valid?
				@tag = Tag.new(params[:tag])
				@user.add_tag(@tag)
				p 'created tag'
				if @tag.valid?
					Event.log(
						"Nuevo Tag",
						"ID: " + @tag.id.to_s + ", Nro. de Serie: " + @tag.uid.to_s + ".",
						"/users/tags/" + @tag.uid.to_s,
						0x009933,
						"new_tag")
					redirect to("/users/tags/" + @tag.uid.to_s)
				else
					Event.log(
						"Tag no se pudo guardar",
						@tag.errors.full_messages.join(', '),
						"/",
						0xEEAAAA,
						"errors")
					redirect to('/')
				end
			else
				Event.log(
					"Tag no se pudo guardar",
					@user.errors.full_messages.join(', '),
					"/",
					0xEEAAAA,
					"errors")
				redirect to('/')
			end
		else
			@tag = Tag.new(params[:tag])
			@tag.user.add_tag(@tag)
			p 'created tag'
			if @tag.valid?
				Event.log(
					"Nuevo Tag",
					"ID: " + @tag.id.to_s + ", Nro. de Serie: " + @tag.uid.to_s + ".",
					"/users/tags/" + @tag.uid.to_s,
					0x009933,
					"new_tag")
				redirect to("/users/tags/" + @tag.uid.to_s)
			else
				Event.log(
					"Tag no se pudo guardar",
					@tag.errors.full_messages.join(', '),
					"/",
					0xEEAAAA,
					"errors")
				redirect to('/')
			end
		end
		
	end

	post '/tags/add_credit/:uid.json' do
		data = JSON.parse(request.body.read)
		@tag = Tag.where(:uid => params[:uid]).first
		if @tag && @tag.user
			@tag.credit += data["add_credit"].to_f
			@tag.save

			Event.log(
				"Tag recargado",
				"ID: " + @tag.uid + ", Crédito: " + @tag.credit.to_s + ".",
				"/tags/id/" + @tag.id.to_s,
				0xEEEEEE,
				"updated_tag")
			return jbuilder :"tags/show"
		else
			halt 404
		end

	end

	delete '/tags/:id' do
		@tag = Tag.find(params[:id])
		@tag.destroy
		halt 204
	end

end
