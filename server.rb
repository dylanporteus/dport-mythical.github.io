require "sinatra/base"
require "pg"
require "bcrypt"



	class Server < Sinatra::Base
		enable :sessions
		set :method_override, true

		get "/" do 
			redirect "/signup"
		end

		get "/signup" do 
			erb :signup
		end
	end



