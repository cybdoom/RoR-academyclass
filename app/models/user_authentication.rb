class UserAuthentication < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user_id, :provider, :uid
  
  def self.find_or_create_user(auth)
    (find_by_provider_and_uid(auth["provider"], auth["uid"]) || create_from_auth(auth)).user
  end
  
  def self.create_from_auth(auth)
    pw = User.generate_password
    user = User.create(:name => auth["info"]["name"], :username => "#{auth["provider"]}#{auth["uid"]}", :user_type => User::DELEGATE, :password => pw, :password_confirmation => pw)
    UserAuthentication.create(:provider => auth["provider"], :uid => auth["uid"], :user_id => user.id)
  end
  
end
