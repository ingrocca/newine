class NewineServer < Sinatra::Application
	post "/variety" do
		@variety = Variety.create(params[:variety])
		format_render 'json', :"variety/show"
	end
end