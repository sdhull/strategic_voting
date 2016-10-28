Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  devise_for :users, controllers: { confirmations: 'users/confirmations',
                                    registrations: 'users',
                                    omniauth_callbacks: 'omniauth_callbacks' }

  post "/messages/forward", to: "messages#incoming", as: :email_processor

  get "about", to: "home#about", as: :about
  get "confirm", to: "home#confirm", as: :confirm
  get "privacy-policy", to: "home#privacy_policy", as: :privacy_policy
  get "terms", to: "home#terms", as: :terms_of_service
  devise_scope :user do
    get "match-preference", to: "users#match_preference", as: :match_preference
    get "update-match-preference", to: "users#update_match_preference", as: :update_match_preference
    get '/users/:id/finish_signup',  to: 'users#finish_signup', as: :finish_signup
  end
  root to: "home#index"
end
