namespace :api, defaults: {format: :json} do
  resources :words, only: %i[], concerns: :words_index do
    collection do
      get "index_scoped_user"
    end

    resources :users, only: %i[] do
      resource :favorite, only: %i[update]
    end
  end

  namespace :user do
    resource :follow_relation, only: %i[update]
  end

  resources :users, only: %i[] do
    scope module: :users do
      resources :follow_relations, only: %i[index]
    end
  end
end
