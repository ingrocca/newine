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
		@view = "index"
		@servings = Serving.all
		@serv_total = Serving.where('created_at > ?', @stat_time).get_stat(:total_count)
		@money_total = Serving.where('created_at > ?', @stat_time).get_stat(:money)
		erb :"servings/index"
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

		if comp && @serving.tag.user.client_type != 'employee' && (@serving.check_remaining_volume)
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

	delete '/servings/:id' do
		@serving = Serving.find(params[:id])
		@serving.destroy
		halt 204
	end

	get '/servings/users' do
		@view = "users"
		@servings = Serving.paginate(:page=>params[:page], :per_page=>20)
		@users = User.where(client_type: ["customer", "manager"])
		erb :"servings/users"
	end

	get '/servings/employees' do
		@view = "employees"
		@employees = User.where(client_type: "employee")
		erb :"servings/employees"
	end
end
