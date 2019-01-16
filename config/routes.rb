# frozen_string_literal: true

Uploader::Engine.routes.draw do
  resources :attachments, only: [:index, :create, :update, :destroy]
end
