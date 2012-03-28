class Users::RegistrationsController < Devise::RegistrationsController
  before_filter :check_permissions, :only => [:new, :create]
  skip_before_filter :require_no_authentication
 
  def check_permissions
    authorize! :manage, User
  end
  
    def new
		@roles = Role.accessible_by(current_ability,:read)
		resource = build_resource({})
		resource.districts.build
		resource.roles.build
		respond_with resource
	end
  
  
  # POST /resource - overriding devise
  def create
    build_resource

    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        #sign_in(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  
end