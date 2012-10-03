# encoding: UTF-8
module UsersHelper

  def details_tag (user)
    return   (raw("<strong>Email: </strong> #{h(user.email)}<br/>")) + \
              (user.phone.blank? ? "" : raw("<strong>Tel.</strong> #{h(user.phone)}<br/>")) + \
              (user.cellphone.blank? ? "" : raw("<strong>Port.</strong> #{h(user.cellphone)}<br/>")) + \
               (user.fax.blank? ? "" : raw("<strong>Fax.</strong> #{h(user.fax)}<br/>"))
  end

  def address_tag (user)
    return raw "<strong>%s</strong>" % (user.company.blank? ? "Entreprise non spécifiée" : h(user.company) ) + \
      "<br/>%s<br/>" % (user.street.blank? ? "Rue non spécifiée" : h(user.street) )+ \
      "%s " % (user.zip.blank? ? "CP non spécifié" : h(user.zip) )+ \
      "%s<br/>" % (user.city.blank? ? "Ville non spécifiée" : h(user.city) )
  end

  def contract_details_tag (user)
    s = ""
    if user.contracts.size == 0
      s += "<strong>Nombre de contrats :</strong> aucun<br/>"
    else
      s += "<strong>Nombre de contrats :</strong> #{h(user.contracts.size)}<br/>"
    end
    if user.file_number == 0
      s += "<strong>Nombre de fichiers :</strong> aucun<br/>"
    else
      s += "<strong>Nombre de fichiers :</strong> %s" % "#{h(user.file_number)}<br/>"
    end
    if user.total_disk_space > 0
      s += "<strong>Espace disque</strong> : #{number_to_human_size user.total_disk_space}"
    end
    return raw(s)
  end
end
