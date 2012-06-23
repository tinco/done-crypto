DoneCrypto::Application.routes.draw do
  resources :users do
    resources :mails
  end
end
