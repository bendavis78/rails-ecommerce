Rails.application.routes.draw do
  post 'add_to_cart' => 'cart#add_to_cart'

  get 'view_order' => 'cart#view_order'

  get 'checkout' => 'cart#checkout'

  post 'order_complete' => 'cart#order_complete'

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", :registrations => "registrations" }

	root 'storefront#all_items'
	get 'categorical/:category_id' => 'storefront#items_by_category', as: 'categorical'
	get 'branding/:brand' => 'storefront#items_by_brand', as: 'branding'

  resources :products
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
