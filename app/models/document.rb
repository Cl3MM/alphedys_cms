# encoding: UTF-8
class Document < ActiveRecord::Base
  versioned

  Paperclip.interpolates :version do |attachment, style|
    attachment.instance.version.to_s
  end

  belongs_to :contract
  attr_accessible :user_id, :uploaded_file, :create_by

  #set up "uploaded_file" field as attached_file (using Paperclip)
  has_attached_file :uploaded_file, :keep_old_files => true,
               :url => "/documents/get/:id/:version",
               :path => ":rails_root/public/system/:id/:version/:basename.:extension"
  validates_attachment_size :uploaded_file, :less_than => 10.megabytes
  validates_attachment_presence :uploaded_file

  def file_extension
    File.extname(uploaded_file_file_name).gsub(".","")
  end

  def file_name
    uploaded_file_file_name
  end

  # Return an array containing a list of all document's versions
  def get_versions
    (versions.map{|n| n.number} << 1).map{|c| c }.sort
  end

end
