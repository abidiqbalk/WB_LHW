class SchoolCouncil < ActiveRecord::Base
	belongs_to :inspection
	belongs_to :bank
	
	validates :balance_available, :numericality => { :only_integer => true}, :allow_blank => true
	validates :total_expenditure, :numericality => { :only_integer => true}, :allow_blank => true
	validates :present_balance, :numericality => { :only_integer => true}, :allow_blank => true
	validates :funds_recieved_from_government, :numericality => { :only_integer => true}, :allow_blank => true
	validates :funds_recieved_from_other, :numericality => { :only_integer => true}, :allow_blank => true
	validates :meetings_held_this_month, :numericality => { :only_integer => true,:greater_than_or_equal_to => 0}, :allow_blank => true
	
end
