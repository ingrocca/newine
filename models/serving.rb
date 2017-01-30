class Serving < ActiveRecord::Base
	belongs_to :wine
	belongs_to :bottle_holder
	belongs_to :tag
	belongs_to :dispenser
	belongs_to :user

	validates :dispenser_id, :presence => true, :numericality => true
	validates :bottle_index, :presence => true, :numericality => true
	validates :price, :presence => :true
	validates :uid, :presence => true


	define_statistic :total_count, :count=>:all, :filter_on => {:dispenser_id => 'dispenser_id = ?', :wine_id => 'wine_id = ?', :user_id => 'user_id = ?'}
	define_statistic :money, :sum => :all, :column_name => 'price', :filter_on => {:dispenser_id => 'dispenser_id = ?', :wine_id => 'wine_id = ?', :user_id => 'user_id = ?'}

	def check_remaining_volume
		(self.bottle_holder.remaining_volume - 10) >= self.volume
	end

	def cost
		(self.volume * self.volume_cost).round(2)
	end
end
