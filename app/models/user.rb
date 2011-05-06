class User < ActiveRecord::Base
  validates_presence_of :email, :password
  validates_size_of(:email, :minimum => 5, :message => "Email must be at least 5 characters.")
  validates_format_of(:email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => "Email is not valid.")
  
  def self.save(upload)
    name =  upload['background'].original_filename
    directory = "public/data"
    ext = File.extname(name)
    
    newName = getRandomStr + ext
    
    path = File.join(directory, newName)
    # write the file
    File.open(path, "wb") { 
      |f| f.write(upload['background'].read) 
    }
    return newName
  end
  
  def self.getRandomStr
    require 'active_support/secure_random'
    randomString = ActiveSupport::SecureRandom.hex(16)
    return randomString
  end
  
end
