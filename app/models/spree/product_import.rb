
module Spree
  class ProductImport < ActiveRecord::Base
    has_one_attached :data_file
    belongs_to :user, class_name: Spree.user_class.to_s

    validate :correct_mine_type

    def correct_mine_type
      if data_file.attached? && !data_file.content_type.in?(%w(text/csv))
        errors.add(:data_file, 'must be a CSV file')
      end
    end
  end
end
