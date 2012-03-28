class Indicator #helper class for gathering global statistics when reporting. Change it up as needed
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  attr_accessor :name, :call_average_method, :alternate_name, :values, :dates, :call_total_method, :hook, :statistics_set_array, :entry_type
 
  validates_presence_of :name, :call_average_method, :call_total_method
  
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
				self.dates[names[level]] = dates_set.collect! {|x| x.beginning_of_month.to_date }
			end
		}
	end
	# puts statistics_set_array.map(&:date_c).empty?
	# if statistics_set_array.map(:date_c).empty?
		# self.dates = Hash.new([])
		# names = [:personal_average, :local_average, :global_average, :super_global_average]
		# self.statistics_set_array.each_with_index {|statistic_set, level| self.dates[names[level]] = statistic_set.map(:date_c).collect! {|x| x.beginning_of_month }}
	# end	
	if self.name.nil?
		self.name = self.entry_type.human_attribute_name(attributes[:hook]).to_s
	end
	if alternate_name.nil?
		self.alternate_name = self.name
	end
	self.statistics_set_array = nil
  end
  
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
  
	def personal_average
		values[:personal_average]
	end
  
	def local_average
		values[:local_average]
	end
  
	def global_average
		values[:global_average]
	end
  
	def super_global_average
		values[:super_global_average]
	end
	
	
	def personal_average_by_date(date)
		value_index = dates[:personal_average].index(date)
		value_index ? values[:personal_average][value_index] : nil
	end
  
	def local_average_by_date(date)
		value_index = dates[:local_average].index(date)
		value_index ? values[:local_average][value_index] : nil
	end
  
	def global_average_by_date(date)
		value_index = dates[:global_average].index(date)
		value_index ? values[:global_average][value_index] : nil		
	end
  
	def super_global_average_by_date(date)
		value_index = dates[:super_global_average].index(date)
		value_index ? values[:super_global_average][value_index] : nil
	end
  
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

  
  def persisted?
    false
  end
end