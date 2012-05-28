class DistrictsController < ApplicationController

before_filter :authenticate_user!
# Doing CanCan calls by hand cause new to this and this a fairly complex usecase

	def compliance_report
		if params[:time_filter].nil?
			@district = District.find(params[:id])
			@start_time = Time.now.beginning_of_month
			@end_time = Time.now.end_of_month
		else
			@district = District.find(params[:time_filter][:id])
			@start_time = Time.zone.parse(params[:time_filter]["start_time(3i)"]+"-"+params[:time_filter]["start_time(2i)"]+"-"+params[:time_filter]["start_time(1i)"])
			@end_time = @start_time.end_of_month
		end	
				
		unless @district.nil?	
			authorize! :view_indicators_reports, @district
			@number_of_months = (@end_time.year*12+@end_time.month) - (@start_time.year*12+@start_time.month) + 1
			
			@province = Province.find(1)
			@province.compliance_statistics(@end_time)
			@district.compliance_statistics(@end_time)
			puts @district.total_expected
			@officers = @district.visitors
			@district.officers_with_compliance_statistics(@start_time,@end_time,@number_of_months,@officers)
			@officers.sort! { |p1, p2| p2.total_percentage <=> p1.total_percentage }
			
			@phone_entries = @district.phone_entries.includes(:visitor).where(:start_time=>(@start_time..@end_time.end_of_day))
			@boundaries = District.get_boundaries(@district)
			
			define_activity_legend
			define_details_images
			respond_to do |format| # why the hell do i need to pull a request.xhr check here...?
				if request.xhr?
					format.js (render 'compliance_report.js.erb')
				else
					format.html (render 'compliance_report.html.erb')
				end
			end
		else
			flash[:error] = "The specified district does not exist."
			redirect_to root_path
		end
		
		rescue ArgumentError
			puts "caught exception!!!~"			
	end

	def indicators_report
		if params[:time_filter].nil?
			@district = District.find_by_district_name(params[:id])
			@start_time = Time.now.prev_month.beginning_of_month
			@end_time = Time.now.prev_month.end_of_month
		else 
			@district = District.find_by_district_name(params[:time_filter][:id])
			@start_time = Time.zone.parse(params[:time_filter]["start_time(3i)"]+"-"+params[:time_filter]["start_time(2i)"]+"-"+params[:time_filter]["start_time(1i)"])
			@end_time = @start_time.end_of_month
		end	
		
		@district = District.find_by_district_name(params[:id])
		unless @district.nil?
			authorize! :view_indicators_reports, @district
			
			@province = @district.province
			@clusters = @district.clusters.order("school_name ASC")
			
			@district.clusters_with_indicator_statistics(@start_time,@end_time,@clusters)
			
			@province.indicator_statistics(@end_time)
			@district.indicator_statistics(@end_time)
			
			@indicators = Assessment.indicators2 + Mentoring.indicators2
		else
			flash[:error] = "The specified district does not exist."
			redirect_to root_path
		end
	end

	def assessments_report
		if params[:time_filter].nil?
			@district = District.find_by_district_name(params[:id])
			@start_time = Time.now.prev_month.beginning_of_month
			@end_time = Time.now.prev_month.end_of_month
		else 
			@district = District.find_by_district_name(params[:time_filter][:id])
			@start_time = Time.zone.parse(params[:time_filter]["start_time(3i)"]+"-"+params[:time_filter]["start_time(2i)"]+"-"+params[:time_filter]["start_time(1i)"])
			@end_time = @start_time.end_of_month
		end	
				
		unless @district.nil?	
			authorize! :view_indicators_reports, @district
			@clusters = @district.clusters_with_assessment_statistics(@start_time,@end_time,@district.clusters.order("school_name ASC"))
			@assessment_indicators = Assessment.indicators([@district.assessment_statistics(@start_time,@end_time,@clusters),Province.assessment_statistics((@start_time),(@end_time))])
			
			@assessment_indicators_by_month = Assessment.indicators([@district.assessment_statistics,Province.assessment_statistics])
			@indicators=[["assessment",@assessment_indicators,@assessment_indicators_by_month ]]
			@collection_names = [@district.name.titleize, "Punjab"]
			@cluster_sets = @clusters.each_slice(15) # for pagination in barcharts
			respond_to do |format|
				format.js
			end
		else
			flash[:error] = "The specified district does not exist."
			redirect_to root_path
		end
		
		rescue ArgumentError
			puts "caught exception!!!~"				
	end
	
	def mentorings_report
		if params[:time_filter].nil?
			@district = District.find_by_district_name(params[:id])
			@start_time = Time.now.prev_month.beginning_of_month
			@end_time = Time.now.prev_month.end_of_month
		else 
			@district = District.find_by_district_name(params[:time_filter][:id])
			@start_time = Time.zone.parse(params[:time_filter]["start_time(3i)"]+"-"+params[:time_filter]["start_time(2i)"]+"-"+params[:time_filter]["start_time(1i)"])

			@end_time = @start_time.end_of_month

		end	
				
		unless @district.nil?	
			authorize! :view_indicators_reports, @district
			@clusters = @district.clusters_with_mentoring_statistics(@start_time,@end_time,@district.clusters.order("school_name ASC"))
			@mentoring_indicators = Mentoring.indicators([@district.mentoring_statistics(@start_time,@end_time,@clusters), Province.mentoring_statistics((@start_time),(@end_time))])
			
			@mentoring_indicators_by_month = Mentoring.indicators([@district.mentoring_statistics,Province.mentoring_statistics])
			@indicators=[["mentoring",@mentoring_indicators,@mentoring_indicators_by_month ]]
			@collection_names = [@district.name.titleize, "Punjab"]
			@cluster_sets = @clusters.each_slice(15) # for pagination in barcharts
			respond_to do |format|
				format.js
			end
		else
			flash[:error] = "The specified district does not exist."
			redirect_to root_path
		end
		
		rescue ArgumentError
			puts "caught exception!!!~"				
	end
	
end
