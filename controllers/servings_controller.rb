class NewineServer < Sinatra::Application

	get  '/report.xls' do
		response['Content-Disposition'] = "attachment; filename=newine_report.xls"
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

	get '/servings/:id.json' do
		@serving = Serving.where(:id => params[:id]).first
		if @serving.nil?
			raise Sinatra::NotFound
		end
		format_render 'json', :"servings/show"
	end
	get '/servings/:id' do
		redirect to('/servings')
	end

	post '/servings.json' do
		data = JSON.parse(request.body.read)
		puts data["serving"]
		@serving = Serving.new(data["serving"])
		#@serving.dispenser.update(last_activity:  Time.now)
		@serving.bottle_holder = @serving.dispenser.bottle_holders.where(dispenser_index: @serving.bottle_index).first
		@serving.wine_id = @serving.bottle_holder.wine.id rescue nil
		@serving.tag = Tag.where(:uid => @serving.uid).first
		#Search price of index of bottle holder
		case @serving.volume
			when @serving.bottle_holder.serving_volume_low
				comp = @serving.bottle_holder.serving_price_low
				discount = @serving.tag.user.category.try(:calculate_low_percentage) || 0
			when @serving.bottle_holder.serving_volume_med
				comp = @serving.bottle_holder.serving_price_med
				discount = @serving.tag.user.category.try(:calculate_med_percentage) || 0 
			when @serving.bottle_holder.serving_volume_high
				comp = @serving.bottle_holder.serving_price_high
				discount = @serving.tag.user.category.try(:calculate_high_percentage) || 0 
			else
				comp = false
		end

		#Check if apply discount 
		if comp && ( ( @serving.tag.user.category && @serving.bottle_holder.discounts) || @serving.bottle_holder.has_special_events )
			discount += @serving.bottle_holder.discounts_special_events
			comp -= (comp * discount)
		end

		if comp && @serving.tag.user.client_type == 'customer' && (@serving.tag.credit - comp) >= 0
			@serving.tag.credit -= comp
		else
			comp = false
		end

		if @serving.tag.user.client_type == 'manager'
			comp = 0 
			discount = 1
		end
		puts "Comp: #{comp}"

		if comp && @serving.tag.user.client_type != 'employee' && (@serving.bottle_holder.remaining_volume >= @serving.volume)
			#descontar si tiene categoria y si lo permite el dispenser
			Serving.transaction do
				@serving.tag.save
				@serving.remaining_credit = @serving.tag.credit if @serving.tag.user.client_type == 'customer'
				@serving.bottle_holder.remaining_volume -= @serving.volume
				@serving.bottle_holder.save
				@serving.user_id = @serving.tag.user.id
				@serving.save		
			end
			Event.log(
				"Compra",
				"Cliente: #{@serving.tag.user.name}, Vino: #{@serving.wine.name}, Precio: #{comp}, Descuento: #{percentage_humanize discount}%",
				"/servings",
				0x55EE88,
				"new_serving")

			if @serving.bottle_holder.remaining_volume < @serving.bottle_holder.serving_volume_high
				Notification.create(description: "Queda poco vino en dispenser: #{@serving.dispenser.uid}, Botella: #{@serving.bottle_index.to_s}", url: "/dispensers/id/#{@serving.dispenser_id.to_s}" )
			end	
		else
			p "Tarjeta sin usuario o error en los datos de medidas"
			@serving.valid_serving = false
		end
		return jbuilder :"servings/show"
	end

	post '/servings_old.json' do
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
			if @serving.tag.user.client_type == 'customer' && (@serving.tag.credit - @serving.remaining_credit).abs < 0.001 && (@serving.bottle_holder.remaining_volume >= @serving.volume)

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
							"/servings",
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
