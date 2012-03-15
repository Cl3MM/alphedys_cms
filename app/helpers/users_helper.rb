# encoding: UTF-8
module UsersHelper
  def details_tag (user)
    return   (user.phone.blank? ? "" : raw("<strong>Tel.</strong> #{user.phone}<br/>")) + \
              (user.cellphone.blank? ? "" : raw("<strong>Port.</strong> #{user.cellphone}<br/>")) + \
               (user.fax.blank? ? "" : raw("<strong>Fax.</strong> #{user.fax}<br/>"))
  end

  def address_tag (user)
    return raw "<strong>%s</strong>" % (user.company.blank? ? "Entreprise non spécifiée" : user.company) + \
      "<br/>%s<br/>" % (user.street.blank? ? "Rue non spécifiée" : user.street) + \
      "%s " % (user.zip.blank? ? "CP non spécifié" : user.zip) + \
      "%s<br/>" % (user.city.blank? ? "Ville non spécifiée" : user.city)
  end
end
