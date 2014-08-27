class User < ActiveRecord::Base
  acts_as_authentic
  validates_presence_of :username, :user_type, :name
  validates_uniqueness_of :username
  
  has_many :user_authentications, :dependent => :destroy
  has_many :user_video_products
  has_many :video_products, :through => :user_video_products
  
  accepts_nested_attributes_for :user_video_products
  
  ADMIN = 1
  SALES = 2
  DELEGATE = 3
  TRAINER = 4

  def name_or_username
    name.blank? ? username : name
  end
  
  def admin?
    return user_type == ADMIN
  end
  
  def sales?
    user_type == SALES
  end
  
  def trainer?
    user_type == TRAINER
  end
  
  def backend_access?
    admin? || sales? || trainer?
  end
  
  def delegate?
    user_type == DELEGATE
  end
  
  def self.find_by_type(type)
    types = type == -1 ? [ADMIN, SALES, TRAINER] : [DELEGATE]
    User.includes(:video_products).where(:user_type => types).order(:name, :username)
  end
  
  def has_video_product_access?(video_product)
    backend_access? || video_products.include?(video_product)
  end
  
  def video_product_ids
    @video_product_ids ||= user_video_products.pluck(:video_product_id)
  end  

  VOWELS = %w(a e i o u)
  CONSONANTS = %w(b c d f g h j k l m n p q r s t v w x y z)
  NUMBERS = ("0".."9").to_a
  
  def self.generate_password
    CONSONANTS[rand(21)] + VOWELS[rand(5)] + CONSONANTS[rand(21)] + VOWELS[rand(5)] + CONSONANTS[rand(21)] + NUMBERS[rand(10)] + NUMBERS[rand(10)]
  end
end