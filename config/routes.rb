Uploader::Engine.routes.draw do
  resources :attachments, :only => [:create, :destroy]
end
