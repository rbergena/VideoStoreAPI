Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :movies, only: [:index, :show, :create]
  get '/movies/:id/current', to:'movies#current', as: 'current_rentals'
  resources :customers, only: [:index]

  get '/rentals/overdue', to: 'rentals#overdue', as: "overdue"
  post 'rentals/check-out', to: 'rentals#checkout', as: "checkout"
  post 'rentals/check-in', to: 'rentals#checkin', as: "checkin"
end
