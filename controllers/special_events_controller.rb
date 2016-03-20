class NewineServer < Sinatra::Application

	get '/special_events' do
		if params[:q]
		else
			@special_events = SpecialEvent.paginate(:page=>params[:page], :per_page=>5)
		end
		format_render 'html', :"special_events/index"
	end	

	post '/special_event/save' do
		@special_event = SpecialEvent.new(params[:special_event])
		@special_event.save
		redirect "/special_events"
	end

	post '/special_events/update/:id' do
		puts params[:special_event]
		@special_event = SpecialEvent.where(id: params[:id]).first
		if(@special_event)
			@special_event.update_attributes(params[:special_event])
		end
		redirect "/special_events"
	end
end