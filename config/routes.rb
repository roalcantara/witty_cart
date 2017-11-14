Rails.application.routes.draw do
  devise_for :users

  authenticate :user, lambda { |u| !u.admin? } do
    root 'home#index'
  end

  authenticate :user, lambda { |u| u.admin? } do
    root "admin/dashboard#index"
    namespace :admin do
      root 'dashboard#index'
      get 'dashboard/index'
    end
  end
end
