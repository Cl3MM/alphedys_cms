class Contract < ActiveRecord::Base
  attr_accessible :name, :price, :start_date, :end_date
  has_many :documents, :dependent => :delete_all
  validates_presence_of :name
end
