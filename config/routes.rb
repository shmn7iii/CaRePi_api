Rails.application.routes.draw do
  post '/session', to: 'sessions/new'
end
