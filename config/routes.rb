Rails.application.routes.draw do
  devise_for :users

  authenticate :user do
    root 'home#index'
  end
end
