require 'spec_helper'.freeze

describe Spree::ProductImport, type: :model do
  let(:simple_csv) do
    fixture_file_upload("files/spree-products-example.csv", "text/csv")
  end

  let(:jpg_file) do
    fixture_file_upload("files/user_image.jpg", "image/jpeg")
  end

  let(:product_import) { build(:product_import, data_file: set_file)}

  before { product_import.valid? }
  describe "Validations" do
    describe "#correct_mine_type" do
      context "when type is valid" do
        let(:set_file) { simple_csv }

        it { expect(product_import.data_file.content_type).to eq("text/csv") }
      end

      context "when type is not valid" do
        let(:set_file) { jpg_file }

        it { expect(product_import.data_file.content_type).not_to eq("text/csv") }
        it { expect(product_import.errors[:data_file]).to include("must be a CSV file") }
      end
    end
  end
end