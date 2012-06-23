class User < ActiveRecord::Base
  attr_accessible :public_key

  def encrypt_file(file)
	  rsa = OpenSSL::PKey::RSA.new(public_key)
	  rsa.public_encrypt(file)
  end
end
