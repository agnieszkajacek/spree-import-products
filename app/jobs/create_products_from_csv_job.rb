class CreateProductsFromCsvJob < ApplicationJob
  queue_as :default

  def perform(product_import)
    Imports::ImportProductsFromCsv.call(
      params: {
        file: product_import.data_file
      }
    )
  end
end