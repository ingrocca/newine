class Staff < ActiveRecord::Base
  validates :name, presence: true
  before_create :format_data

  private
  def format_data
    self.name = self.name.titleize
    self.token = (1..6).inject(''){ |str| str + rand(0..9).to_s }
  end
end
