require "./app"
#require "sinatra/activerecord/rake"

require "./nfc"

namespace :db do
  desc "Seed intial data"
  task :seed do
    Admin.create email: "admin@example.com", password: "123456" if Admin.count == 0
    if Category.count == 0
      Category.create name: 'Cliente', low_percentage: 0, med_percentage: 0, high_percentage: 0
      Category.create name: 'Staff', low_percentage: 100, med_percentage: 100, high_percentage: 100
      Category.create name: 'Gerente', low_percentage: 100, med_percentage: 100, high_percentage: 100
    end
  end
end
