class Ability

include CanCan::Ability

=begin
Assigns abilities to user when session is created via [CanCan](https://github.com/ryanb/cancan). Also [worth reading](http://www.tonyamoyal.com/2010/07/28/rails-authentication-with-devise-and-cancan-customizing-devise-controllers/)
@param [User] user the user object being loaded into session
=end
	def initialize(user)
		user ||= User.new # guest user
		
		if user.role? "Super Administrator"
			can :manage, :all
			cannot :manage, Role, :name => "Super Administrator"
			cannot :view, User do |other_user|
				other_user.role? "Super Administrator" and other_user!=user
			end
			cannot :disable_users, User do |other_user|
				other_user==user
			end
		end

		if user.role? "User Administrator"
			can :manage, User 
			cannot :disable_users, User
			can :manage, Role
			cannot :manage, Role, :name => "Super Administrator"
			cannot [:view], User do |other_user|
				other_user.role? "Super Administrator"
			end
		end	
		
		if user.role? "Province Manager"
			can :view_compliance_reports, District
			can :view_indicators_reports, :all
		end	
		
		if user.role? "District Manager"
			can :view_compliance_reports, District, :id => user.district_ids
			can :view_indicators_reports, District, :id => user.district_ids
		end	
		
	end
end
