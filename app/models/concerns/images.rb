module Images
  extend ActiveSupport::Concern

  def decode_image(img, file_name)
    Base64.decode64(img)
    file_decode(img.split(',')[1], file_name) if img
  rescue ArgumentError
    nil
  end

  private

  def file_decode(base, filename)
    file = Tempfile.new([file_base_name(filename), file_extn_name(filename)])
    file.binmode
    file.write(Base64.decode64(base))
    file
  end

  def file_base_name(file_name)
    File.basename(file_name, file_extn_name(file_name))
  end

  def file_extn_name(file_name)
    File.extname(file_name)
  end
end