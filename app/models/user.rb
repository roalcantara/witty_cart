class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :cart, foreign_key: :owner_id

  after_save :create_cart!, if: -> { cart.nil? }, unless: -> { admin? }

  def username
    email.split('@').first
  end

  private

  def create_cart!
    build_cart.save
  end
end
