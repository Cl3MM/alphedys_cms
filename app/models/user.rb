class User < ActiveRecord::Base
  has_secure_password
  has_many :contracts, :dependent => :delete_all

  attr_accessible :email, :password, :password_confirmation,
                  :role, :firstname, :lastname, :company,
                  :phone, :cellphone, :fax, :street, :zip,
                  :city

  validates_uniqueness_of :email
  validates_presence_of :email, :password_confirmation, :password_confirmation
  validates :password, :confirmation => true

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

  def disk_space
    contracts.reduce(0) do |result, c|
      result += c.documents.reduce(0) {|r, s| r += s.uploaded_file_file_size }
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
end
