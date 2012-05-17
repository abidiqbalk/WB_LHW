class ApplicationController < ActionController::Base
  protect_from_forgery

	rescue_from CanCan::AccessDenied do |exception|
		flash[:error] = exception.message
		logger.debug "DEBUGGING"
		logger.debug exception.action 
		logger.debug exception.subject 
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
  
  def define_activity_legend
	gon.assessment_marker = view_context.image_path("phones-red.png")
	gon.mentoring_marker = view_context.image_path("phones-green.png")
	gon.pdpst_marker = view_context.image_path("phones-yellow.png")
	gon.pddte_marker = view_context.image_path("phones-teal.png")
	gon.default_marker = view_context.image_path("phones-green.png")
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
