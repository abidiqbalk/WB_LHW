class IllegalOccupation < ActiveRecord::Base
	
	belongs_to :inspection
	attr_accessor :illegal_occupation_check
	
  def occupied_from_string
    if self.new_record?
      I18n.l(Time.current, :format => "%d-%m-%Y")
    else
      I18n.l(arrival_date, :format => "%d-%m-%Y")
    end
end

def occupied_from_string=(occupied_from_str)
   self.occupied_from = Time.zone.parse(occupied_from_str)
  rescue ArgumentError
    @occupied_from_invalid = true
end
	
end
