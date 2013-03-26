Dummy::Application.routes.draw do
  match "/home(.:format)", :to => "home#index", :as => :home
  match "/home/subdir_template(.:format)", :to => "home#subdir_template", :as => :subdir_template
end
