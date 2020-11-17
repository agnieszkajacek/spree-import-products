
module Spree
  class ProductImport < ActiveRecord::Base
    has_one_attached :data_file
    belongs_to :user
  end
end
