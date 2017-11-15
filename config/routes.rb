Rails.application.routes.draw do
  devise_for :users

  authenticate :user, lambda { |u| !u.admin? } do
    root 'products#index'

    resources :products, only: %i(index show)
  end

  authenticate :user, lambda { |u| u.admin? } do
    root "admin/dashboard#index"

    namespace :admin do
      root 'dashboard#index'

      resources :dashboard, only: %i(index)
      resources :users, only: %i(index show)
      resources :products
    end
  end
end
