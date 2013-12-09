class NewineServer < Sinatra::Application

	get  '/report.xls' do
		response['Content-Disposition'] = "attachent; filename=newine_report.xls"
    	content_type 'application/xls'

		params[:t] = 1 if !params[:t]
		@stat_time = params[:t].to_i.days.ago
		@servings = Serving.all
		@serv_total = Serving.where('created_at > ?', @stat_time).get_stat(:total_count)
		@money_total = Serving.where('created_at > ?', @stat_time).get_stat(:money)
		erb :"servings/index.xls", :layout => false
	end

	get  '/servings.json' do
		@servings = Serving.all
		jbuilder :"servings/index"
	end

	get  '/servings' do
		params[:t] = 1 if !params[:t]
		@stat_time = params[:t].to_i.days.ago
		@servings = Serving.all
		@serv_total = Serving.where('created_at > ?', @stat_time).get_stat(:total_count)
		@money_total = Serving.where('created_at > ?', @stat_time).get_stat(:money)
		erb :"servings/index"
	end

	get '/servings/:id.?:format?' do
		@serving = Serving.where(:id => params[:id]).first
		if @serving.nil?
			raise Sinatra::NotFound
		end
		format_render params[:format], :"servings/show"
	end

	post '/servings.json' do
		data = JSON.parse(request.body.read)
		@serving = Serving.new(data["serving"])
		p 'created serving'
		p @serving
		if @serving.valid?

			@serving.dispenser.last_activity = Time.now
			@serving.dispenser.save

			@serving.bottle_holder = @serving.dispenser.bottle_holders.where(:dispenser_index => @serving.bottle_index).first

			case @serving.volume
				when @serving.bottle_holder.serving_volume_low
					p "low"
					comp = (@serving.price - @serving.bottle_holder.serving_price_low).abs < 0.001
				when @serving.bottle_holder.serving_volume_med
					p 'med'
					comp = (@serving.price - @serving.bottle_holder.serving_price_med).abs < 0.001
				when @serving.bottle_holder.serving_volume_high
					p 'high'
					comp = (@serving.price - @serving.bottle_holder.serving_price_high).abs < 0.001
				else
					p "No valid volume"
					comp = false
			end
			p "Price error" if !comp


			@serving.wine_id = @serving.bottle_holder.wine.id rescue nil

			@serving.tag = Tag.where(:uid => @serving.uid).first
			if comp && @serving.tag && @serving.tag.user && (@serving.tag.credit - @serving.remaining_credit).abs < 0.001 && (@serving.bottle_holder.remaining_volume >= @serving.volume)

				@serving.tag.credit -= @serving.price rescue 0
				if @serving.tag.nil? || (@serving.tag.credit <= 0 && !(@serving.tag.user.client_type == 'manager' || @serving.tag.user.client_type == 'superclient')) || !@serving.wine
					p "Invalid serving data: " +
						(@serving.tag.nil? ? "Tag inexistente " : ( (@serving.tag.credit <= 0) ? "Credito insuficiente " : "")) +
						(@serving.wine.nil? ? "Vino inexistente " : "")
					@serving.valid_serving = false
				else
					Serving.transaction do
						@serving.tag.save
						@serving.remaining_credit = @serving.tag.credit
						@serving.bottle_holder.remaining_volume -= @serving.volume
						@serving.bottle_holder.save
						@serving.user_id = @serving.tag.user.id
						@serving.save
									
					end
					Event.log(
							"Compra",
							"Cliente: " + @serving.tag.user.name + ", Vino: " + @serving.wine.name + ", Precio: " + @serving.price.to_s,
							"/servings/" + @serving.id.to_s,
							0x55EE88,
							"new_serving")

					if @serving.bottle_holder.remaining_volume < @serving.bottle_holder.serving_volume_high
						Event.log(
							"Queda poco vino",
							"Dispenser: " + @serving.dispenser.uid + ", Botella: " + @serving.bottle_index.to_s,
							"/dispensers/id/" + @serving.dispenser_id.to_s,
							0xAA1111,
							"empty_bottle")
					end		
					$channel.push({:serving => { :bottle_holder_id => @serving.bottle_holder_id, :volume_percent => (@serving.bottle_holder.remaining_volume.to_f * 100 / @serving.bottle_holder.wine.volume),
													:remaining_volume => @serving.bottle_holder.remaining_volume }}.to_json);
				end
			else
				p "Tarjeta sin usuario o error en los datos de medidas"
				@serving.valid_serving = false
			end
				
			return jbuilder :"servings/show"

			
		else
			@serving.valid_serving = false
			return @serving.to_json
		end
	end

	delete '/servings/:id' do
		@serving = Serving.find(params[:id])
		@serving.destroy
		halt 204
	end

end