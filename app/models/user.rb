class User < ActiveRecord::Base
  attr_accessible :public_key
  attr_accessible :private_key

  has_many :mails

  def encrypt(data)
    result = aes_encrypt(data)
    rsa = OpenSSL::PKey::RSA.new(public_key)
    key = rsa.public_encrypt(result[:key])
    iv = rsa.public_encrypt(result[:iv])
    result.merge!({:key => key, :iv => iv})
  end

  def aes_encrypt(data)
    aes = OpenSSL::Cipher::AES.new(256, :CBC).encrypt
    key = aes.random_key
    iv = aes.random_iv
    encrypted = aes.update(data) + aes.final
    {:data => encrypted, :key => key, :iv => iv}
  end
end
