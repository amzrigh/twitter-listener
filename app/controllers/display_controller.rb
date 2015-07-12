class DisplayController < ApplicationController
  def home
  	@posts = Post.where("rating >= 0").limit(2).order("RANDOM()")
  end
end
