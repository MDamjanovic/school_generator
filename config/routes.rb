Rails.application.routes.draw do
  mount Upmin::Engine => '/admin'
  root to: 'visitors#index'

  resources :students, only: [:update]
  
  resources :schools do
  collection do
    get :generate_students
    post :generate_students
    get :schedule_students
    post :schedule_students
  end
  end

  devise_for :users
  resources :users
end
