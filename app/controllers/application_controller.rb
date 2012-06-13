class ApplicationController < ActionController::Base
  protect_from_forgery

	rescue_from CanCan::AccessDenied do |exception|
		flash[:error] = exception.message
		redirect_to root_url
	end

	
	  #----------------------------------------------------------------------------
  def respond_to_not_found(*types)
    asset = self.controller_name.singularize
    flick = case self.action_name
      when "destroy" then "delete"
      when "promote" then "convert"
      else self.action_name
    end
    if self.action_name == "show"
      # If asset does exist, but is not viewable to the current user..
      if asset.capitalize.constantize.exists?(params[:id])
        flash[:warning] = t(:msg_asset_not_authorized, asset)
      else
        flash[:warning] = t(:msg_asset_not_available, asset)
      end
    else
      flash[:warning] = t(:msg_cant_do, :action => flick, :asset => asset)
    end
    respond_to do |format|
      format.html { redirect_to :action => :index }                          if types.include?(:html)
      format.js   { render(:update) { |page| page.reload } }                 if types.include?(:js)
      format.json { render :text => flash[:warning], :status => :not_found } if types.include?(:json)
      format.xml  { render :text => flash[:warning], :status => :not_found } if types.include?(:xml)
    end
  end

  #----------------------------------------------------------------------------
  def respond_to_related_not_found(related, *types)
    asset = self.controller_name.singularize
    asset = "note" if asset == "comment"
    flash[:warning] = t(:msg_cant_create_related, :asset => asset, :related => related)
    url = send("#{related.pluralize}_path")
    respond_to do |format|
      format.html { redirect_to url }                                        if types.include?(:html)
      format.js   { render(:update) { |page| page.redirect_to url } }        if types.include?(:js)
      format.json { render :text => flash[:warning], :status => :not_found } if types.include?(:json)
      format.xml  { render :text => flash[:warning], :status => :not_found } if types.include?(:xml)
    end
  end
  
  def indicators_init

		@activities = PhoneEntry.activities
		
		@indicators = []
		@indicator_names= Hash.new
		@indicator_hooks= Hash.new
	
		for activity in @activities
			indicators = activity.indicators2.find_all{|indicator| indicator.indicator_type == "integer" }
			@indicator_names[activity.name] = indicators.collect {|indicator| indicator.full_name} 
			@indicator_hooks[activity.name] = indicators.collect {|indicator| indicator.indicator_activity.name+"_"+indicator.hook} 
			@indicators += indicators
		end
		
		gon.indicator_names = @indicator_names
		gon.indicator_hooks = @indicator_hooks		
		gon.flash_path = view_context.asset_path('copy_csv_xls_pdf.swf')

  end
  
  def define_activity_legend
	gon.markers = []
	for activity in PhoneEntry.activities
		gon.markers.append(view_context.image_path(activity.name.to_s+".png"))
	end
  end
  
  def define_school_legend
	gon.default_marker = view_context.image_path("phones-default.png")
	gon.school_marker = view_context.image_path("university.png")
	gon.ctsc_marker = view_context.image_path("star-yellow.png")
  end
  
  def define_details_images
	gon.details_open = view_context.image_path("details_open.png")
	gon.details_close = view_context.image_path("details_close.png")
  end
  

  
end
