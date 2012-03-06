class Contract < ActiveRecord::Base
  attr_accessible :name, :price, :startdate, :endate
  has_many :documents
  validates_presence_of :name
end
