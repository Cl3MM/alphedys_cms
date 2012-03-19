class User < ActiveRecord::Base
  has_secure_password
  has_many :contracts, :dependent => :delete_all

  attr_accessible :email, :password, :password_confirmation,
                  :role, :firstname, :lastname, :company,
                  :phone, :cellphone, :fax, :street, :zip,
                  :city

  validates_uniqueness_of :email, :on => :create
  validates_presence_of :email
  validates :password,
    :confirmation => true,
    :length => { :minimum => 10, :maximum => 40 },
    :on => :create

  validates_presence_of :password_confirmation, :on => :create

  before_create { generate_token(:auth_token) }

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def is_admin?
    self.role == "admin" ? true : false
  end

  def role?(role)
    self.role == role.to_s
  end

  def total_disk_space
    contracts.reduce(0) do |result, c|
      result += c.documents.reduce(0) do |res, doc|
        if doc.versions.empty?
          res += doc.uploaded_file_file_size
        else
          versions = (doc.versions.map{|n| n.number} << 1).sort
          res += versions.reduce(doc.uploaded_file_file_size) do |size, v|
            # binding.pry
            doc.revert_to(v)
            size += doc.uploaded_file_file_size
          end
        end
      end
    end
  end

  def disk_space
    contracts.reduce(0) do |result, c|
      result += c.documents.reduce(0) do |r, doc|
        r += doc.uploaded_file_file_size
      end
    end
  end

  def file_number
    contracts.reduce(0) do |result, c|
      result += c.documents.size
    end
  end

  def name_tag
    ((firstname && lastname).nil?  ? email : "#{firstname.capitalize} #{lastname.upcase}")
  end

  # return an array containing the ids of the user's documents
  def user_document_ids
    contracts.map{|c| c.documents.map{|d| d.id}.flatten }.flatten.compact
  end

end
