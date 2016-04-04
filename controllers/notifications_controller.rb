class NewineServer < Sinatra::Application
	get "/notifications" do
		@notifications = Notification.paginate(:page=>params[:page], :per_page=>10)
		format_render 'html', :"notifications/index"
	end

	post "/notifications/:id/read" do |id|
		@notification = Notification.find(id)
		@notification.update(read: true)
		redirect '/notifications'
	end
end