Sms::Engine.routes.draw do
  resource :config, only: [:show, :new, :create, :edit, :update]

  resources :messages, only: [] do 
    post :resend, on: :member
    post :cancel, on: :member
  end

  namespace :api, defaults: { format: "json" } do
    namespace :v1 do
      post "api_sms_status_response", to: "messages#api_sms_status_response"
      post "api_sms_response", to: "responses#api_sms_response"
    end
  end

  get "log", to: "log#index"
end
