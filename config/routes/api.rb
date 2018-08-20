namespace :api, defaults: {format: :json} do
  resources :words, only: %i[], concerns: :words_index do
    collection do
      get "index_scoped_user"
    end
  end
end
