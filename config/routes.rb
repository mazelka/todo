Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create, :index, :destroy]
      resources :projects, :shallow => true do
        resources :tasks do
          member do
            put 'move_lower'
            put 'move_higher'
          end
          resources :comments, only: [:create, :destroy, :index]
        end
      end
      post 'user_token' => 'user_token#create'
    end
  end

  get '/api' => redirect('/swagger/dist/index.html?url=/docs/swagger/v1/swagger.json')
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
