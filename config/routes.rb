Rails.application.routes.draw do
  resources :users, only: [:create, :index, :destroy]
  post 'user_token' => 'user_token#create'
  get '/api' => redirect('/swagger/dist/index.html?url=/swagger/v1/swagger.json')
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
