class Favorite < ActiveRecord::Base
  belongs_to :post
  belongs_to :user

  after_create :send_favorite_emails

  private

  def send_favorite_emails
    self.post.favorites.each do |favorite|
      FavoriteMailer.new_comment( favorite.user, self.post, self ).deliver
    end
  end
  
end
