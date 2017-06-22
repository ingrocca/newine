#coding: utf-8
class NewineServer < Sinatra::Application
	get '/tag-movements' do
		today = Time.now
		params[:q]['created_at_lteq'] = DateTime.parse("#{params[:q]['created_at_lteq']} 23:59:59 +0300") if params[:q]['created_at_lteq']
		params[:q] = { created_at_gteq: Date.parse("#{today.year}-#{today.month}-01"), created_at_lteq: today } unless params[:q]
		@q = TagMovement.ransack(params[:q])
		@total = @q.result.sum(:credit)
		@tag_movements = @q.result.order('created_at desc').paginate(:page=>params[:page], :per_page=>20)

		format_render 'html', :"tag_movements/index"
	end
end
