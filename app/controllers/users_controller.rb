class UsersController < ApplicationController
  before_filter :get_user, :only => [:index,:new,:edit]
  before_filter :accessible_roles, :only => [:disable_account,:index,:new,:destroy,:edit, :show, :update, :create]
  load_and_authorize_resource :only => [:disable_account,:enable_account,:index,:show,:new,:destroy,:edit,:update]
  
  # GET /users
  # GET /users.xml                                                
  # GET /users.json                                       HTML and AJAX
  #-----------------------------------------------------------------------
  def index
    @users = User.order('created_at DESC').select { |u| can? :view, u }
    respond_to do |format|
      format.json { render :json => @users }
      format.xml  { render :xml => @users }
      format.html
    end
  end
  
	def edit
		respond_to do |format|
			format.json { render :json => @user }   
			format.xml  { render :xml => @user }
			format.html 
		end
		rescue ActiveRecord::RecordNotFound
			respond_to_not_found(:json, :xml, :html)
	end

	def disable_account
		@user.disable
		flash[:warning] = "#{@user.username} has been disabled."
		respond_to do |format|
			format.json { render :json => @user }   
			format.xml  { render :xml => @user }
			format.html { redirect_to users_path}
		end
		rescue ActiveRecord::RecordNotFound
			respond_to_not_found(:json, :xml, :html)
	end	
	
	def enable_account
		@user.enable
		flash[:warning] = "#{@user.username} has been enabled."
		respond_to do |format|
			format.json { render :json => @user }   
			format.xml  { render :xml => @user }
			format.html { redirect_to users_path}
		end
		rescue ActiveRecord::RecordNotFound
			respond_to_not_found(:json, :xml, :html)
	end

  # PUT /users/1
  # PUT /users/1.xml
  # PUT /users/1.json                                            HTML AND AJAX
  #----------------------------------------------------------------------------
   def update
    if params[:user][:password].blank?
      [:password,:password_confirmation,:current_password].collect{|p| params[:user].delete(p) }
	end

	if @user.role? "Super Administrator"
		params[:user][:role_ids] = params[:user][:role_ids] + [Role.where(:name=>"Super Administrator").first.id]
	end
	
    respond_to do |format|
      if @user.errors[:base].empty? and @user.update_attributes(params[:user])
        flash[:notice] = "Your account has been updated"
        format.json { render :json => @user.to_json, :status => 200 }
        format.xml  { head :ok }
        format.html { render :action => :edit }
      else
        format.json { render :text => "Could not update user", :status => :unprocessable_entity } #placeholder
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
        format.html { render :action => :edit, :status => :unprocessable_entity }
      end
    end
  end
  
  
  # Get roles accessible by the current user
  #----------------------------------------------------
  def accessible_roles
    @accessible_roles = Role.accessible_by(current_ability,:read)
  end
 
  # Make the current user object available to views
  #----------------------------------------
  def get_user
    @current_user = current_user
  end
  
  
	def compliance_report
		
		if params[:time_filter].nil?
			@officer = Visitor.find(params[:id])
			@start_time = Time.now.prev_month.beginning_of_month
			@end_time = Time.now.prev_month.end_of_month
		else
			@officer = Visitor.find(params[:time_filter][:id])
			@start_time = Time.zone.parse(params[:time_filter]["start_time(3i)"]+"-"+params[:time_filter]["start_time(2i)"]+"-"+params[:time_filter]["start_time(1i)"])
			@end_time = @start_time.end_of_month
		end	
		
		unless @officer.nil?
			@district = @officer.district
			authorize! :view_compliance_reports, @district 
			@boundaries = District.get_boundaries(@district)
			define_activity_legend
			
			@officer.compliance_statistics(@end_time)
			@district.compliance_statistics(@end_time)
			
			# @a_count = @officer.assessments.where(:start_time=>(@start_time..@end_time.end_of_day)).count
			# @m_count = @officer.mentorings.where(:start_time=>(@start_time..@end_time.end_of_day)).count
			# @p_count = @officer.pd_psts.where(:start_time=>(@start_time..@end_time.end_of_day)).count
			# @d_count = @officer.pd_dtes.where(:start_time=>(@start_time..@end_time.end_of_day)).count
			@phone_entries = @officer.phone_entries.where(:start_time=>(@start_time..@end_time.end_of_day)).order("DATE(start_time) DESC")
			respond_to do |format| # why the hell do i need to pull a request.xhr check here...?
				if request.xhr?
					format.js (render 'compliance_report.js.erb')
				else
					format.html (render 'compliance_report.html.erb')
				end
			end
		else
			flash[:error] = "Can't find the specified officer"
			redirect_to root_path
		end
		
		rescue ArgumentError
			puts "caught exception!!!~"			
	end
	
	def indicators_report
		if params[:time_filter].nil?
			@officer = Visitor.find(params[:id])
			@start_time = Time.now.prev_month.beginning_of_month
			@end_time = Time.now.prev_month.end_of_month
		else
			@officer = Visitor.find(params[:time_filter][:id])
			@start_time = Time.zone.parse(params[:time_filter]["start_time(3i)"]+"-"+params[:time_filter]["start_time(2i)"]+"-"+params[:time_filter]["start_time(1i)"])
			@end_time = @start_time.end_of_month
		end	
		
		unless @officer.nil?
			@district = @officer.district
			authorize! :view_compliance_reports, @district 
			indicators_init
						
			@district.indicator_statistics_for_visitors(@end_time, @activities)
			@officer.indicator_statistics(@end_time, @activities)
			
			@phone_entries = @officer.phone_entries
			
		else
			flash[:error] = "The specified officer does not exist."
			redirect_to root_path
		end
	end
	
  
end