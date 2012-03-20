# encoding: UTF-8
module UsersHelper

  def details_tag (user)
    return   (raw("<strong>Email: </strong> #{user.email}<br/>")) + \
              (user.phone.blank? ? "" : raw("<strong>Tel.</strong> #{user.phone}<br/>")) + \
              (user.cellphone.blank? ? "" : raw("<strong>Port.</strong> #{user.cellphone}<br/>")) + \
               (user.fax.blank? ? "" : raw("<strong>Fax.</strong> #{user.fax}<br/>"))
  end

  def address_tag (user)
    return raw "<strong>%s</strong>" % (user.company.blank? ? "Entreprise non spécifiée" : user.company) + \
      "<br/>%s<br/>" % (user.street.blank? ? "Rue non spécifiée" : user.street) + \
      "%s " % (user.zip.blank? ? "CP non spécifié" : user.zip) + \
      "%s<br/>" % (user.city.blank? ? "Ville non spécifiée" : user.city)
  end

  def contract_details_tag (user)
    if user.contracts.size == 0
      s = "<strong>Nombre de contrats :</strong> aucun<br/>"
    else
      s = "<strong>Nombre de contrats :</strong> #{user.contracts.size}<br/>"
    end
    if user.file_number == 0
      s += "<strong>Nombre de fichiers :</strong> aucun<br/>"
    else
      s += "<strong>Nombre de fichiers :</strong> %s" % "#{user.file_number}<br/>"
    end
    if user.total_disk_space > 0
      s += "<strong>Espace disque</strong> : #{number_to_human_size user.total_disk_space}"
    end
    return raw(s)
  end

end
