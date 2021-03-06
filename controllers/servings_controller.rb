class NewineServer < Sinatra::Application

  get  '/report.xls' do
    today = Time.now
    params[:q]['created_at_lteq'] = DateTime.parse("#{params[:q]['created_at_lteq']} 23:59:59") unless params[:q].nil?
    params[:q] = { created_at_gteq: Date.parse("#{today.year}-#{today.month}-01"), created_at_lteq: today } unless params[:q]
    @q = Serving.ransack(params[:q])
    @servings = @q.result
    @serv_total = @servings.get_stat(:total_count)
    @money_total = @servings.get_stat(:money)
    response['Content-Disposition'] = "attachment; filename=newine_report.xls"
    content_type 'application/xls'
    erb :"servings/index.xls", :layout => false
  end

  get  '/servings.json' do
    @servings = Serving.all
    jbuilder :"servings/index"
  end

  get '/servings' do
    today = Time.now
    params[:q]['created_at_lteq'] = DateTime.parse("#{params[:q]['created_at_lteq']} 23:59:59") unless params[:q].nil?
    params[:q] = { created_at_gteq: Date.parse("#{today.year}-#{today.month}-01"), created_at_lteq: today } unless params[:q]
    @q = Serving.ransack(params[:q])
    @servings = @q.result
    @serv_total = @servings.get_stat(:total_count)
    @money_total = @servings.get_stat(:money)
    @wines = Wine.find(@servings.map(&:wine_id).uniq)
    @dispensers = Dispenser.find(@servings.map(&:dispenser_id).uniq)
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

    if comp && ((@serving.tag.credit - comp) >= 0)
      @serving.tag.credit -= comp
    else
      comp = false
    end

    puts "Comp: #{comp}"

    if comp && @serving.remaining_volume?
      #descontar si tiene categoria y si lo permite el dispenser
      Serving.transaction do
        @serving.tag.save
        @serving.remaining_credit = @serving.tag.credit
        @serving.price = comp
        @serving.bottle_holder.remaining_volume -= @serving.volume
        @serving.bottle_holder.save
        @serving.user_id = @serving.tag.user.id
        @serving.volume_cost = @serving.bottle_holder.wine.try(:volume_cost)
        @serving.save
      end
      Event.log(
        "Compra",
        "Cliente: #{@serving.tag.user.name}, Vino: #{@serving.wine.name}, Cantidad: #{@serving.volume} ml, Precio: $ #{comp}, Descuento: #{percentage_humanize discount}%",
        "/servings",
        0x55EE88,
        "new_serving")
    else
      p "Tarjeta sin usuario o error en los datos de medidas"
      @serving.valid_serving = false
    end
    return jbuilder :"servings/show"
  end

  post '/servings_back_office.json' do
    data = JSON.parse(request.body.read)
    puts data["serving"]
    @serving = Serving.new(data["serving"].merge(mode: 'back_office'))
    @serving.bottle_holder = @serving.dispenser.bottle_holders.where(dispenser_index: @serving.bottle_index).first
    @serving.wine_id = @serving.bottle_holder.wine.id rescue nil
    if @serving.valid_volume? && @serving.remaining_volume?
      Serving.transaction do
        @serving.bottle_holder.remaining_volume -= @serving.volume
        @serving.bottle_holder.save
        @serving.save
      end
      Event.log(
        "Back Office",
        "Vino: #{@serving.wine.name}, Cantidad: #{@serving.volume} ml",
        "/servings",
        0x55EE88,
        "new_serving_back_office")
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
    today = Time.now
    params[:q]['created_at_lteq'] = DateTime.parse("#{params[:q]['created_at_lteq']} 23:59:59") unless params[:q].nil?
    params[:q] = { created_at_gteq: Date.parse("#{today.year}-#{today.month}-01"), created_at_lteq: today } unless params[:q]
    @q = Serving.ransack(params[:q])
    @servings = @q.result.paginate(:page=>params[:page], :per_page=>20)
    erb :"servings/users"
  end

  get '/servings/back_offices' do
    @view = "back_offices"
    today = Time.now
    params[:q]['created_at_lteq'] = DateTime.parse("#{params[:q]['created_at_lteq']} 23:59:59") unless params[:q].nil?
    params[:q] = { created_at_gteq: Date.parse("#{today.year}-#{today.month}-01"), created_at_lteq: today } unless params[:q]
    @q = Serving.ransack(params[:q].merge(mode_eq: 'back_office'))
    @servings = @q.result.paginate(:page=>params[:page], :per_page=>20)
    erb :"servings/back_offices"
  end

  get '/servings/activities' do
    @view = "activities"
    today = Time.now
    params[:q]['created_at_lteq'] = DateTime.parse("#{params[:q]['created_at_lteq']} 23:59:59") unless params[:q].nil?
    params[:q] = { created_at_gteq: Date.parse("#{today.year}-#{today.month}-01"), created_at_lteq: today } unless params[:q]
    @q = Event.ransack(params[:q].merge(event_type: ["taste","change_bottle"]))
    @activities = @q.result
    erb :"servings/activities"
  end
end
