class User < ActiveRecord::Base
  attr_accessible :public_key

  has_many :mails

  def encrypt_file(file)
	  rsa = OpenSSL::PKey::RSA.new(public_key)
	  rsa.public_encrypt(file)
  end
end
