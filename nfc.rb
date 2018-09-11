require './app'

namespace :nfc do
	task :work do

		begin
			cache =  NewineServer.cache

			p "Opening context"
			ctx = NFC::Context.new
			p "Opening device"
			devnm = "pn532_i2c:/dev/i2c-2"
			# Open the first available USB device
			dev = ctx.open devnm

			p "Starting loop"
			loop do
				while(cache.get('nfc_uid'))
					sleep(0.020)
				end

				d = dev.poll 1, 1

				if d.respond_to?(:<) && d<0 && d!=-90
					p d
					raise "NFC Error!"
				end

				if d.respond_to? :uid
					p "Tag found"
					cache.set('nfc_uid',d.uid.map{|n| "%02x"%n}.join(''))
				end
				sleep 0.05
				#dev.deselect
			end
		rescue Exception => e
			p "Error!"
			p e.message
			raise e
		end
	end
end
