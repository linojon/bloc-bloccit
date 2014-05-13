class Post < ActiveRecord::Base
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :favorites, dependent: :destroy
  
  belongs_to :user
  belongs_to :topic

  mount_uploader :image, ImageUploader
  
  #default_scope { order('created_at DESC') }
  default_scope { order('rank DESC') }
  scope :visible_to, ->(user) { user ? all : joins(:topic).where('topics.public' => true) }

  validates :title, length: { minimum: 5 }, presence: true
  validates :body, length: { minimum: 20 }, presence: true
  validates :topic, presence: true
  validates :user, presence: true

  after_create :create_vote

  def up_votes
    self.votes.where(value: 1).count
  end

  def down_votes
    self.votes.where(value: -1).count
  end

  def points
    self.votes.sum(:value).to_i
  end

  def update_rank
    # each day of age is equivalent to a down vote, so it decays over time
    age = (self.created_at - Time.new(1970,1,1)) / 86400 # age in days
    new_rank = points + age

    self.update_attribute(:rank, new_rank)
  end

  private

  def create_vote
    user.votes.create( value: 1, post: self )
  end

end
