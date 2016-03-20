class SpecialEvent < ActiveRecord::Base
	has_and_belongs_to_many :bottle_holders
	has_and_belongs_to_many :dispensers
	
	validates :type_special_event, inclusion: { in: %w(discount happy_hour), message: "%{value} no es un tipo válido"}
	validates :percentage, inclusion: { in: 1..100 }, if: Proc.new { |obj| obj.percentage.present? }


	def special_event_type_human
		case type_special_event
		when 'discount'
			'Descuento'
		when 'happy_hour'
			"Happy hour"
		else
			type_special_event
		end
	end
end