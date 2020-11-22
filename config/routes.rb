Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :product_imports, only: [:index, :new, :create]
    get "/product_import_details", to: "product_imports#import_details"
  end
end