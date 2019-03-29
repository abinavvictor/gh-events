Rails.application.routes.draw do
  root('events#home')

  get('events/', to: 'events#home')
  get('events/:login', to: 'events#list')
end
