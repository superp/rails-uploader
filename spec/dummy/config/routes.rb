Rails.application.routes.draw do
  mount Uploader::Engine => '/uploader'
end
