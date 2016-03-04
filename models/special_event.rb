class SpecialEvent < ActiveRecord::Base
	has_and_belongs_to_many :bottle_holders
	has_and_belongs_to_many :dispensers

	validates :percentage, inclusion: { in: 1..100 }, if: Proc.new { |obj| obj.percentage.present? }
end