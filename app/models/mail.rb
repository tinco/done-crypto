class Mail < ActiveRecord::Base
  attr_accessible :body
  belongs_to :user

  def self.process(user, mail)
    # remove unwanted/incorrect lines and whitespace
    # find keywords to add to word cloud or analysis
    # be careful not to leak information that can
    # be traced back to this mail!
    mail.body
  end

  def self.receive_mail(user, mail)
    body = process user,mail
    mail = Mail.new :body => user.encrypt_file(body)
    mail.user = user
    mail.save
  end
end
