require './app'

namespace :nfc do 
	task :work do

		cache =  NewineServer.cache
		
		ctx = NFC::Context.new

		devnm = "pn532_i2c:/dev/i2c-1"
		# Open the first available USB device
		dev = ctx.open devnm

		
		loop do
			while(cache.get('nfc_uid'))
				sleep(0.020)
			end

			d = dev.poll 1, 1

			if d.respond_to? :uid
				cache.set('nfc_uid',d.uid.map{|n| "%02x"%n}.join(''))
			end
			sleep 0.05
			#dev.deselect
		end
	end
end
