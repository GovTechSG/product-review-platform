module Images
  extend ActiveSupport::Concern

  def decode_image(img, file_name)
    Base64.decode64(img)
    data_format = img.split(',')
    data = data_format[1]
    if data_format[0] =~ %r{(?<=/)(.*)(?=;)}
      format = Regexp.last_match[0]
      return file_decode(data, "#{file_name}.#{format}") if img && data
    end
    nil
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