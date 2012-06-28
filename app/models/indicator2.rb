=begin
Helper class for gathering global statistics when reporting. Change it up as needed.
=end
class Indicator2
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  attr_accessor :full_name, :short_name, :suffix, :call_average_method, :call_total_method, :indicator_type, :hook, :indicator_activity, :table_display_type
 
#  validates_presence_of :name, :call_average_method, :call_total_method
=begin
Constructor. Usually you just need to specify the entry_type, alternate_name, hook and statistics_set_array.
@param [String] name The long name of the indicator for display and identification purposes.
@param [String] alternate_name The short name of the indicator for display and identification purposes.
@param [String] Hook (optional) if specified, the indicator generates the call_total_method, call_average_method and name on the basis of this string.
@param [PhoneEntry] PhoneEntry activity from which the indicator is derived for display and identification purposes.
@param [Hash] statistics_set_array stores ALL statistics. The indicator figures out the data it needs to pull from the call_average_method and call_total_method params. 
@param [Symbol] call_average_method The method the indicator should call to retrieve its average value from the statistics_set_array. Does not need to be specified if the hooks parameter has been specified.
@param [Symbol] call_total_method The method the indicator should call to retrieve its total value from the statistics_set_array. Does not need to be specified if the hooks parameter has been specified.
@param [Hash of Floats] values (optional) hash of averages for the indicator in question. Normally derived from the call_average_method. Stores personal, local, global and super global averages as needed.  
@param [Hash of Dates] dates (optional) hash of dates (one for each month) for which the the indicator has monthwise values. Normally derived from statistics_set_array  
@return [Indicator] A new instance of Indicator
=end
	def initialize(attributes = {})
		attributes.each do |name, value|
		  send("#{name}=", value)
		end
		self.call_average_method = (attributes[:hook]+"_average").to_sym
		self.call_total_method = (attributes[:hook]+"_total").to_sym
		#meow = Object.const_set("assessment_detail".classify, Class.new)
		if self.full_name.nil?
			self.full_name = Kernel.const_get(self.indicator_activity.name+"Detail").human_attribute_name(self.hook)
		end
		
		if self.short_name.nil?
			self.short_name = Kernel.const_get(self.indicator_activity.name+"Detail").human_attribute_name(self.hook+"_short")
		end
		
		if self.suffix.nil?
		end

		if self.indicator_type.nil?
			self.indicator_type = "integer"
		end
		
		if self.table_display_type.nil?
			self.table_display_type = "total"
		end

		if self.indicator_type == "integer" and self.suffix.nil?
			temp = Kernel.const_get(self.indicator_activity.name+"Detail").human_attribute_name(self.hook+"_suffix")
			self.suffix = temp.index('suffix').nil? ? temp : nil 
		end
	end

	
  def persisted? #necessary fix for activemodel. No need to modify.
    false
  end
end