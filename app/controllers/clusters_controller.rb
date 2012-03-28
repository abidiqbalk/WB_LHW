class ClustersController < ApplicationController


	def school_report
		if params[:time_filter].nil?
			@cluster = Cluster.find(params[:id])
			@start_time = Time.now.prev_month.beginning_of_month
			@end_time = Time.now.prev_month.end_of_month
		else 
			@cluster = Cluster.find(params[:time_filter][:id])
			@start_time = Time.zone.parse(params[:time_filter][:start_time])
			@end_time = Time.zone.parse(params[:time_filter][:end_time])
		end	
				
		unless @cluster.nil?	
			@district = @cluster.district
			authorize! :view_school_reports, @district
			@schools = @cluster.schools_with_statistics(@start_time,@end_time,@cluster.schools.order("school_name ASC"))
			@assessment_indicators = Assessment.indicators([@cluster.assessment_statistics(@start_time,@end_time,@schools),@district.assessment_statistics((@start_time),(@end_time))])
			@mentoring_indicators = Mentoring.indicators([@district.mentoring_statistics(@start_time,@end_time,@clusters),@district.mentoring_statistics((@start_time),(@end_time))])
			
			@assessment_indicators_by_month = Assessment.indicators([@cluster.assessment_statistics,@district.assessment_statistics])
			@mentoring_indicators_by_month = Mentoring.indicators([@cluster.mentoring_statistics,@district.mentoring_statistics])
			
			@collection_names = ["Cluster", "District"]
			@school_sets = @schools.each_slice(15)
			
			#@school = @district.assessment_details.where('phone_entries.start_time' => time_range)
			# School.find_by_emiscode(39330003).assessment_details[0].assessment
			respond_to do |format| # why the hell do i need to pull a request.xhr check here...?
				if request.xhr?
					format.js (render 'school_report.js.erb')
				else
					format.html (render 'school_report.html.erb')
				end
			end
		else
			flash[:error] = "The specified cluster does not exist."
			redirect_to root_path
		end
		
		rescue ArgumentError
			puts "caught exception!!!~"			
	end

end
