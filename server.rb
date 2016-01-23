require "sinatra/base"
require "pg"
require "bcrypt"
require "pry"



	class Server < Sinatra::Base
		enable :sessions
		set :method_override, true

		@@db = PG.connect(dbname: "mythical_db_test")

		def current_user
			if session["user_id"]
				@user ||= @@db.exec_params(<<-SQL, [session["user_id"]]).first
				  SELECT * FROM users 
				  WHERE id = $1
				SQL
			else
				#The empty object will signify that a user is not logged in.
			   {}
			end
		end


		get "/" do 
			redirect "/signup"
		end

		get "/signup" do 
			erb :signup
		end

		post "/signup" do 
			encrypted_password = BCrypt::Password.create(params[:password])

			users = @@db.exec_params(<<-SQL, [params[:username], encrypted_password])
			  INSERT INTO users (username, password_digest) 
			  VALUES ($1, $2) RETURNING id;
			SQL

			session["user_id"] = users.first["id"]

			erb :signup_success

		end


		get "/login" do 
           erb :login 
		end

		post "/login" do
         @user = @@db.exec_params("SELECT * FROM users WHERE username = $1", [params[:username]]).first
         if @user 
         	if BCrypt::Password.new(@user["password_digest"]) == params[:password]
         	  session["user_id"] = @user["id"]
         	  
         	  redirect "/login_success"
         	else
         		@error = "Invalid Password"
         		erb :login 
         	end
         else
         	@error = "Invalid Username"
         	erb :login 
         end


		end

		get "/login_success" do 
			erb :login_success
		end

		
		get "/topics" do
		@new_topics = @@db.exec_params("SELECT topics.*, users.username 
			FROM topics 
			LEFT JOIN users 
			ON topics.user_id = users.id").to_a 
			erb :topics
		end
		




		post "/topics" do 
			
			user_id = session["user_id"] 
			

			topics = @@db.exec_params(<<-SQL, [params[:topic_title], user_id]) 
			INSERT INTO topics (topic_title, user_id) 
			VALUES ($1, $2) RETURNING id;
			SQL

			@new_topics = @@db.exec_params("SELECT topics.*, users.username 
			FROM topics 
			LEFT JOIN users 
			ON topics.user_id = users.id").to_a 
			
			erb :topics
		end



		
	end



