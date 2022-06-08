Rails.application.routes.draw do
  resources :tasks
  post 'tasks/:id/active' => 'tasks#active', as: :completed_task
end
