Rails.application.routes.draw do

  scope module: 'api', defaults: { format: :json } do
    get 'api/government_urls/search' => 'government_url#search'
  end
 
end
