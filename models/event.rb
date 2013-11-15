class Event < ActiveRecord::Base

	def self.log(ti,d,l,c,ty)
		self.create(:title => ti, :description => d, :link_url => l, :color => c, :event_type => ty)
	end
end