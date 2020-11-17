module Spree
  module Admin
    class ProductImportsController < BaseController

      def index
        redirect_to :action => :new
      end

      def new
        @product_import = Spree::ProductImport.new
      end

      def create
        @product_import = ProductImport.new(product_import_params)
        @product_import.file_name = product_import_params[:data_file].original_filename
        @product_import.user_id = spree_current_user.id
        @product_import.save

        CreateProductsFromCsvJob.perform_later(@product_import)

        redirect_to admin_products_path
      end

      private
        def product_import_params
          params.require(:product_import).permit(:data_file)
        end
    end
  end
end
