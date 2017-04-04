require "./app"
#require "sinatra/activerecord/rake"

require "./nfc"

namespace :db do
  desc "Seed intial data"
  task :seed do
    Admin.create email: "admin@example.com", password: "123456", password_confirmation: "123456", username: "admin"
  end
end
