Rails.application.routes.draw do
  root to: 'welcome#index'

  match 'reload', to: 'welcome#reload', via: :get
  match 'clear', to: 'welcome#clear', via: :delete
end
