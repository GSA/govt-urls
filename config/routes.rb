Rails.application.routes.draw do

  scope module: 'api' do
  	root 'government_url#index'
    get 'government_urls/search' => 'government_url#search', defaults: { format: 'json' }
  end
 
end
