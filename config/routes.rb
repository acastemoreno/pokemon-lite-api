Rails.application.routes.draw do
  resources :pokemons do
    resources :trainers, module: :pokemons
  end

  resources :trainers do
    resources :pokemons, module: :trainers
  end
end
