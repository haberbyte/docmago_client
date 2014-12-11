Dummy::Application.routes.draw do
  get '/home(.:format)', to: 'home#index', as: :home
  get '/home/subdir_template(.:format)', to: 'home#subdir_template', as: :subdir_template
end
