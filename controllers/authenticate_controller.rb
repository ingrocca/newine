class NewineServer < Sinatra::Application

	get '/login' do
		erb :login, locals: { username: ""}
	end

	post '/login' do
	  if login(Admin, params["username"].downcase, params["password"])
	    remember(authenticated(Admin)) if params["remember_me"]
	    flash[:success] = "Has iniciado sesión correctamente."
	    redirect "/"
	  else
	    flash[:error] = "Combinación de nombre de usuario y/o contraseña no válida."
	    erb :login, locals: { username: params["username"] } 
	  end
	end

	get "/logout" do
  	logout(Admin)
  	redirect "/"
	end
end
