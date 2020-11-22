# frozen_string_literal: true

module Imports
  class ImportProductsFromCsv < UseCase
    require 'csv'

    arguments :file

    def persist
      import_csv
    end

    private

    def import_csv
      records = []

      begin
        Spree::Product.transaction do
          parsed_csv.each do |row|
            return if product(row["name"])

            shipping_category = find_or_create_shipping_category(row["category"])
            create_product(row, shipping_category)
          end
        end
      rescue ActiveRecord::RecordInvalid => exception
        puts exception.message
      end
    end

    def parsed_csv
      CSV.parse(file.download, headers: true, encoding: 'ISO-8859-1', col_sep: ";")
    end

    def create_product(row, shipping_category)
      product = Spree::Product.create!(
        name: row["name"],
        slug: row["slug"],
        description: row["description"],
        shipping_category_id: shipping_category.id,
        available_on: row["availability_date"],
        price: row["price"]
      )

      product.master.stock_items.first.update_attributes!(count_on_hand: row["stock_total"])
    end

    def find_or_create_shipping_category(category_name)
      Spree::ShippingCategory.find_or_create_by(name: category_name)
    end

    def product(name)
      @product ||= Spree::Product.find_by(name: name)
    end
  end
end