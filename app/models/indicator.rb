=begin
Helper class for gathering global statistics when reporting. Change it up as needed.
=end
class Indicator 
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  attr_accessor :name, :call_average_method, :alternate_name, :values, :dates, :call_total_method, :hook, :statistics_set_array, :entry_type
 
  validates_presence_of :name, :call_average_method, :call_total_method
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
    attributes.each do |name, local_average|
      send("#{name}=", local_average)
    end
	if self.call_average_method.nil?
		self.call_average_method = (attributes[:hook]+"_average").to_sym
	end
	
	if self.call_total_method.nil?
		self.call_total_method = (attributes[:hook]+"_total").to_sym
	end
	if self.values.nil?
		self.values = Hash.new([])
		self.dates = Hash.new([])
		names = [:personal_average, :local_average, :global_average, :super_global_average]
		self.statistics_set_array.each_with_index {|statistic_set, level| 
			self.values[names[level]] = statistic_set.map(&((attributes[:hook]+"_average_c")).to_sym).collect! {|x| x.to_f.round(1) }
			dates_set = statistic_set.map(&:date_c)
			if !dates_set.empty?
				self.dates[names[level]] = dates_set.collect! {|x| x.try(:beginning_of_month).try(:to_date) }
			end
		}
	end
	
	if self.name.nil?
		self.name = self.entry_type.human_attribute_name(attributes[:hook]).to_s
	end
	if alternate_name.nil?
		self.alternate_name = self.name
	end
	self.statistics_set_array = nil
  end

=begin
returns the chronological month the indicator has a value for. 
@param [Integer] level the level of date that is requested. Valid values are from 0-3  
@param [Integer] month the chronological number of the month.
@return [DateTime] A DateTime to determine the month in question.
=end
	def date_by_index(*args)
		case args[0]
		when 0
			dates[:personal_average][args[1]]
		when 1
			dates[:local_average][args[1]]
		when 2
			dates[:global_average][args[1]]
		when 3
			dates[:super_global_average][args[1]]
		end
	end
	
=begin
returns the value the indicator at the specified level and chronological. 
@param [Integer] level the level of month that is requested. Valid values are from 0-3  
@param [Integer] date the chronological number of the value entry.
@return [Array of Floats] The statistics stored at the specified locations.
=end	
	def values_by_date(level, date)
		case level
		when 0
			 [personal_average_by_date(date)]
		when 1
			 [personal_average_by_date(date)] + [local_average_by_date(date)]
		when 2
			 [personal_average_by_date(date)] + [local_average_by_date(date)] + [global_average_by_date(date)]
		when 3
			 [personal_average_by_date(date)] + [local_average_by_date(date)] + [global_average_by_date(date)] + [super_average_by_date(date)]
		end
	end
  
	def personal_average # Alias method
		values[:personal_average]
	end
  
	def local_average # Alias method
		values[:local_average]
	end
  
	def global_average # Alias method
		values[:global_average]
	end
  
	def super_global_average # Alias method
		values[:super_global_average]
	end
	
	
	def personal_average_by_date(date) # Alias method
		value_index = dates[:personal_average].index(date)
		value_index ? values[:personal_average][value_index] : nil
	end
  
	def local_average_by_date(date) # Alias method
		value_index = dates[:local_average].index(date)
		value_index ? values[:local_average][value_index] : nil
	end
  
	def global_average_by_date(date) # Alias method
		value_index = dates[:global_average].index(date)
		value_index ? values[:global_average][value_index] : nil		
	end
  
	def super_global_average_by_date(date) # Alias method
		value_index = dates[:super_global_average].index(date)
		value_index ? values[:super_global_average][value_index] : nil
	end
	
=begin
Returns value of entries at a particular level
@param [Integer] level the level that is requested. Valid values are from 0-3  
@param [Integer] month the chronological month that is requested. This is optional and should only be called if the indicator is storing monthwise data.  
@return [Integer] The number of entries stored at a particular level.
=end
  def level(*args) 
	case args[0]
	when 0
		args[1] ? [personal_average[args[1]]] : personal_average
	when 1
		args[1] ? [personal_average[args[1]]] + [local_average[args[1]]] : personal_average + local_average
	when 2
		args[1] ? [personal_average[args[1]]] + [local_average[args[1]]] + [global_average[args[1]]]  : personal_average + local_average + global_average
	when 3
		args[1] ? [personal_average[args[1]]] + [local_average[args[1]]] + [global_average[args[1]]] + [super_global_average[args[1]]] : personal_average + local_average + global_average + super_global_average
	end
  end

=begin
Returns number of entries at a particular level
@param [Integer] level the level that is requested. Valid values are from 0-3  
@return [Integer] The number of entries stored at a particular level.
=end
  def level_count(*args) 
	case args[0]
	when 0
		personal_average.size
	when 1
		local_average.size
	when 2
		global_average.size
	when 3
		super_global_average.size
	end
  end

  def persisted? #necessary fix for activemodel. No need to modify.
    false
  end
end