Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  scope path: '/api' do
    # User Routes
    get '/signed_in', to: 'users#signed_in'

    get '/users', to: 'users#index'
    get '/users/:id', to: 'users#show'

    post '/sign_in', to: 'users#sign_in'
    post '/sign_up', to: 'users#sign_up'

    put '/users/:id', to: 'users#update'
    patch '/users/:id', to: 'users#update'

    delete '/sign_out', to: 'users#sign_out'
    delete '/users/:id', to: 'users#destroy'
  end
end
