class Contract < ActiveRecord::Base
  attr_accessible :name, :price, :start_date, :end_date
  has_many :documents, :dependent => :delete_all
  validates_presence_of :name

  def contract_disk_space
    ret = documents.reduce(0) do |res, doc|
      if doc.versions.empty?
        res += doc.uploaded_file_file_size
      else
        versions = (doc.versions.map{|n| n.number} << 1).sort
        res += versions.reduce(0) do |size, v|
          doc.revert_to(v)
          size += doc.uploaded_file_file_size
        end
      end
    end
    return ret.nil? ? 0 : ret
  end
end
