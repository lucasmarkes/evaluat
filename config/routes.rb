Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  resources :students, except: [:edit] do
    get 'search', on: :collection
  end

  resources :school_classes, except: [:edit] do
    get 'search', on: :collection
  end

  resources :quizzes, except: [:update, :edit] do
    get "answer_quiz"
    post "finish_quiz"
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  root "dashboard#index"

  # Defines the root path route ("/")
end
