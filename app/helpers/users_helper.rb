# encoding: UTF-8
module UsersHelper
  def address_tag (user)
    return raw "<strong>%s</strong>" % (user.company.nil? ? "Entreprise non spécifiée" : user.company) + \
      "<br/>%s<br/>" % (user.street.nil? ? "Rue non spécifiée" : user.street) + \
      "%s " % (user.zip.nil? ? "CP non spécifié" : user.zip) + \
      "%s<br/>" % (user.city.nil? ? "Ville non spécifiée" : user.city)
  end
end
