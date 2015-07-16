class ImportWorker
  include Sidekiq::Worker

  def perform(class_name)
    class_name.constantize.new.import_and_if_possible_purge_old
  end
end