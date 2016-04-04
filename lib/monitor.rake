task :monitor do
	Dispenser.all.each do |d|
		d.bottle_holders.each do |bh|
			if bh.check_bottle_status
				Notification.create(description:"La posición #{bh.dispenser_index} del dispenser #{d.uid} contiene una botella (#{bh.wine.name} #{bh.wine.variety} #{bh.wine.vintage}) que hace #{bh.wine.open_days} días que está abierta",url: "/dispensers/id/#{d.id.to_s}")
			end
			if bh.check_bottle_cleaned				
				Notification.create(description:"La posición #{bh.dispenser_index} del dispenser #{d.uid} hace más de 7 días que no se limpia",url: "/dispensers/id/#{d.id.to_s}")
			end
		end 
	end
end