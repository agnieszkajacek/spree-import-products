class CreateProductsFromCsvJob < ApplicationJob
  queue_as :default

  def perform(product_import)
    return if product_import.data_file.blank?

    Imports::ImportProductsFromCsvUseCase.call(
      params: {
        file: product_import.data_file,
        product_import_id: product_import.id
      }
    )
  end
end