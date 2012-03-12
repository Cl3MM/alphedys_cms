class Document < ActiveRecord::Base
  versioned

  Paperclip.interpolates :version do |attachment, style|
    attachment.instance.version.to_s
  end

  belongs_to :contract
  attr_accessible :user_id, :uploaded_file

#  has_attached_file :document, :keep_old_files => true,
#    :url => "/reports/:id/versions/:version/:basename.:extension",
#    :path => ":rails_root/assets/reports/:id/:version/:basename.:extension"

  #set up "uploaded_file" field as attached_file (using Paperclip)
  has_attached_file :uploaded_file, :keep_old_files => true,
               :url => "/documents/get/:id/version/:version",
               :path => ":rails_root/public/system/:id/:version/:basename.:extension"
  validates_attachment_size :uploaded_file, :less_than => 10.megabytes
  validates_attachment_presence :uploaded_file

  def file_name
    uploaded_file_file_name
  end
end
