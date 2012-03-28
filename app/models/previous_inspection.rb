class PreviousInspection < ActiveRecord::Base
belongs_to :inspection

  def date_of_inspection_string
    if self.new_record?
      I18n.l(Time.current, :format => "%d-%m-%Y")
    else
      I18n.l(date_of_inspection, :format => "%d-%m-%Y")
    end
end

def date_of_inspection_string=(date_of_inspection_str)
   self.date_of_inspection = Time.zone.parse(date_of_inspection_str)
  rescue ArgumentError
    @date_of_inspection_invalid = true
end

end
