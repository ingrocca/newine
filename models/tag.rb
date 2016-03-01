class Tag < ActiveRecord::Base
	validates :uid, :uniqueness => true, :presence=>true
	belongs_to :user
	validates :user, :presence => true 

	after_initialize :init

  def init
  	self.credit ||= 0
  end

end