Rails.application.routes.draw do
  root to: 'welcome#index'

  match 'reload', to: 'welcome#reload', via: :get
end
