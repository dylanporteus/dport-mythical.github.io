require "sinatra/base"
require "pg"
require "bcrypt"



	class Server < Sinatra::Base
		enable :sessions
		set :method_override, true

		@@db = PG.connect(dbname: "mythical_db_test")

		get "/" do 
			redirect "/signup"
		end

		get "/signup" do 
			erb :signup
		end

		post "/signup" do 
			encrypted_password = BCrypt::Password.create(params[:login_password])

			users = @@db.exec_params(<<-SQL, [params[:email], params[:username], encrypted_password])
			  INSERT INTO users (email, username, password_digest) VALUES ($1, $2, $3) RETURNING id;
			SQL

			session["user_id"] = users.first["id"]

			erb :signup_success

		end



		
	end



