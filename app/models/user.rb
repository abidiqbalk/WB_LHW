# == Schema Information
#
# Table name: users
#
#  id                     :integer(4)      not null, primary key
#  name                   :string(255)     not null
#  district_id            :integer(4)      not null
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(255)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer(4)      default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  is_active              :boolean(1)      default(TRUE), not null
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  username               :string(255)
#

class User < ActiveRecord::Base
	has_and_belongs_to_many :roles
	has_and_belongs_to_many :districts
	# Include default devise modules. Others available are:
	# :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
		 :recoverable, :rememberable, :trackable, :validatable

	# Setup accessible (or protected) attributes for your model
	attr_accessible :username,:email, :password, :password_confirmation, :remember_me, :district_ids, :name, :district_id, :role_ids
	validates :username, :length => { :minimum => 4, :message => "Must be at least 4 letters long." }
	def email_required?
		false
	end

	#this method is called by devise to check for "active" state of the model
	def active_for_authentication?
		#remember to call the super
		#then put our own check to determine "active" state using 
		#our own "is_active" column
		super and self.is_active?
	end
	
	def authenticate_admin
		super and self.is_active? and can :manage, User
	end

	def disable
		self.is_active=0
		self.save!
	end
	
	def enable
		self.is_active=1
		self.save!
	end
	
	def role?(role)
		return !!self.roles.find_by_name(role.to_s)
	end
	
	def districts_by_role
		if self.role? "Province Manager" or self.role? "Super Administrator"
			District.order("district_name ASC")
		else
			self.districts.order("district_name ASC")
		end
	end
	
end
