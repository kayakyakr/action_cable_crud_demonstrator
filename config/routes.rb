Rails.application.routes.draw do
  devise_for :users
  match "/toptal_cable", to: ActionCable.server, via: [:get, :post]

  get '(*jspath)' => "home#index"
  root to: "home#index"
end
