class Tag < ActiveRecord::Base
	validates :uid, :uniqueness => true, :presence=>true
	belongs_to :user
	validates :user, :presence => true
	validates :credit, :presence => true, :numericality => { :greater_than_or_equal_to => 0 }

	after_initialize :init

  def init
  	self.credit ||= 0
  end

end