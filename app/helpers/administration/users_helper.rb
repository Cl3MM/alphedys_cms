module Administration::UsersHelper

  def get_image_from_ext file
    file_types = %w{pdf doc xls zip ppt docx xlsx txt png avi mpg ods odt rar jpg gif csv bmp mp3 pptx }
    ext = File.extname(file).gsub(".","")
    if file_types.include? ext
      img_path = "files_types/icon_#{ext}.png"
    else
      img_path = "files_types/icon_generic.png"
    end
    return img_path
  end

end
