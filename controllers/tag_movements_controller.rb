#coding: utf-8
class NewineServer < Sinatra::Application
	get '/tag-movements' do
		date_start = { created_at_gteq: Time.now.midnight } unless params[:q]
		date_end = { created_at_lteq: Time.now } unless params[:q]
		params[:q] = date_start.merge(date_end) unless params[:q]
		
		@q = TagMovement.ransack(params[:q])
		@total = @q.result.sum(:credit)
		@tag_movements = @q.result.order('created_at desc').paginate(:page=>params[:page], :per_page=>20)

		format_render 'html', :"tag_movements/index"
	end
end