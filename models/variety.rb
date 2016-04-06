class Variety < ActiveRecord::Base
	has_many :wines

	validates :name, :presence=>true	
end