namespace :tematres do
  desc 'Import terms and metadata from Tematres'
  task import: :environment do
    TematresImporter.new.import
  end

  desc 'Recreate government urls index'
  task recreate_index: :environment do
  	GovernmentUrl.recreate_index
  end

end

