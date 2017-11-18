class User < ApplicationRecord
  include Signinable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :cart, foreign_key: :owner_id

  validates :name, presence: true

  after_save :create_cart!, if: -> { cart.nil? }, unless: -> { admin? }
  after_create :track_sign_up

  def username
    email.split('@').first
  end

  def first_name
    name&.split(' ')&.first || username
  end

  private

  def create_cart!
    build_cart.save
  end

  def track_sign_up
    Woopra::TrackerService.track_sign_up self
  end
end
