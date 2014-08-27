class TweetsController < ApplicationController

  def index
    @tweets = Tweet.order("created DESC")
  end
end