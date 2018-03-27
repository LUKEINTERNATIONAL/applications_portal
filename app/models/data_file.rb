class DataFile < ActiveRecord::Base
  def self.save(upload, fname)
    
    upload.each do |file|
    
      # name =  file.original_filename
      directory = "public/data"
      # create the file path
      path = File.join(directory, fname)
      # write the file
      File.open(path, "wb") { |f| f.write(file.read) }
      
    end
  end
end
