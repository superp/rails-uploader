Uploader::Engine.routes.draw do
  resources :attachments, :only => [:create, :update, :destroy]
end
