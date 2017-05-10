class User < ActiveRecord::Base

	has_many :tags, dependent: :destroy
	has_many :servings
	belongs_to :category
	has_many :complementary_drinks

	validates :name, :presence=>true
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, format: { with: VALID_EMAIL_REGEX }, :allow_blank => true

	def to_s
		"#{name} #{surname}"
	end

	def current_tag
		tag = tags.last
		tag if tag && tag.active?
	end

	def add_tag(tag)
		if current_tag
			tag.credit += current_tag.credit 
			current_tag.update(active: false)
		end
		tag.user = self if tag.user.nil?
		tag.active = true
		tag.save 
	end
end
