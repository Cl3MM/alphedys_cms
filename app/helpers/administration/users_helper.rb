module Administration::UsersHelper

  def get_image_from_ext file
    file_types = %w{pdf doc xls zip ppt docx xlsx}
    ext = File.extname(file).gsub(".","")
    if file_types.include? ext
      img_path = "files_types/icon_#{ext}.gif"
    else
      img_path = "files_types/icon_generic.gif"
    end
    return img_path
  end

end
