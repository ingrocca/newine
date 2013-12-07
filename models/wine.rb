class Wine < ActiveRecord::Base
	has_many :bottle_holders

	validates :name, :presence=>true
	validates :vintage, :presence=>true
	validates :variety, :presence=>true
	validates :volume, :presence=>true, :numericality=>true
end