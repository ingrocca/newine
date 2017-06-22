class NewineServer < Sinatra::Application
  get '/staffs' do
    @staffs = Staff.paginate(:page=>params[:page], :per_page=>5)
    format_render 'html', :"staffs/index"
  end

  get '/staffs/:id' do |id|
    @staffs = Staff.where(id: id).paginate(:page=>params[:page], :per_page=>5)
    format_render 'html', :"staffs/index"
  end

  post '/staffs' do
    @staff = Staff.create(params[:staff])
    if @staff.valid?
      @staff.save
      redirect "staffs/#{@staff.id}"
    else
      flash[:error] = "Ocurrió un error creando #{@staff.errors.messages}"
      redirect "/staffs"
    end
  end
end
