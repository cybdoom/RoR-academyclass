class SalesContact < ActiveRecord::Base
  validates_presence_of :name, :email
  
  def to_s
    "#{name} <#{email}>"
  end
end