#coding: utf-8
class NewineServer < Sinatra::Application
	get '/tag-movements' do
		@q = TagMovement.ransack(params[:q])
		@total = @q.result.sum(:credit)
		@tag_movements = @q.result.order('created_at desc').paginate(:page=>params[:page], :per_page=>20)

		format_render 'html', :"tag_movements/index"
	end
end