namespace :tematres do
  desc 'Import terms and metadata from Tematres'
  task import: :environment do
  	ImportWorker.perform_async('TematresImporter')
  end

  desc 'Recreate government urls index'
  task recreate_index: :environment do
  	GovernmentUrl.recreate_index
  end

end

