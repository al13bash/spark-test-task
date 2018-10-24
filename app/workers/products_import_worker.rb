class ProductsImportWorker
  include Sidekiq::Worker

  def perform(file_path)
    outcome = ProductsImportService.new(file_path: file_path).run
    logger.info(outcome.errors.full_messages) unless outcome.valid?
  end
end
