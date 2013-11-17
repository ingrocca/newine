class Event < ActiveRecord::Base

	def self.log(ti,d,l,c,ty)
		ev = self.create(:title => ti, :description => d, :link_url => l, :color => c, :event_type => ty)

		$channel.push({:evnt => ev}.to_json)

	end
end