class SpecialEvent < ActiveRecord::Base
	belongs_to :bottle_holder
	belongs_to :dispenser

	validates :percentage, inclusion: { in: 1..100 }, if: Proc.new { |obj| obj.percentage.present? }
end