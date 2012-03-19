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

  def contract_details_tag (user)
    return   raw(
              "<strong>Nombre de contrats :</strong> %s" % (user.contracts.size == 0 ? "aucun" : "#{user.contracts.size}<br/>") + \
              "<strong>Nombre de fichiers :</strong> %s" % (user.file_number == 0 ? "aucun" : "#{user.file_number}<br/>") + \
              ("<strong>Espace disque</strong> : #{number_to_human_size user.disk_space}" if user.total_disk_space > 0)
              )
  end

end
