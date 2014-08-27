require 'grackle'

class Tweet < ActiveRecord::Base

  MY_APPLICATION_NAME = "AcademyClass"
  
  """Connect to the Twitter API and pull down the latest tweets"""
  def self.get_latest
    tweets = client.statuses.user_timeline? :screen_name => MY_APPLICATION_NAME # hit the API
    tweets.each do |t|
      # create the tweet if it doesn't already exist
      unless Tweet.where(:twitter_id => t.id_str).exists?
        created = DateTime.parse(t.created_at)
        Tweet.create({:content => t.text, :created => created, :twitter_id => t.id_str, :name => t.user.name, :profile_image => t.user.profile_image_url })
       end
    end
  end
  
  private
  def self.client
    Grackle::Client.new(:auth=>{
      :type=>:oauth,
      :consumer_key=>'SR1sEhJf4VPNTAK8b5zXfw',
      :consumer_secret=>'v7jvr3bwcHYgDXmB8mFlkbVvA1HbTpx4nsB3DbKog',
      :token=>"15834279-ZlYgYvOkK7eYDOBAGge28QTc3rXRmMwWAv7B1kWEj",
      :token_secret=>"PZ4Vd8sBm3trDz6W3hOXCvR8fLodubsYZ6xwneiSfUU"
    })

  end
end