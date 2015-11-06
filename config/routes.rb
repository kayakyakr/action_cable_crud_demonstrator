Rails.application.routes.draw do
  devise_for :users
  match "/action_cable_demonstrator_cable", to: ActionCable.server, via: [:get, :post]

  get '(*jspath)' => "home#index"
  root to: "home#index"
end
