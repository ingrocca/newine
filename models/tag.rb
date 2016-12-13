class Tag < ActiveRecord::Base
	belongs_to :user
	has_many :tag_movements, :dependent => :destroy

	validates :uid, :uniqueness => true, :presence=>true
	validates :user, :presence => true
	validates :credit, :presence => true, :numericality => { :greater_than_or_equal_to => 0 }

	after_initialize :init

  def init
  	self.credit ||= 0
  end

  def active?
  	self.active && check_due_date
  end

  def check_due_date
  	self.due_date >= Time.now
  rescue
  	true
  end
end