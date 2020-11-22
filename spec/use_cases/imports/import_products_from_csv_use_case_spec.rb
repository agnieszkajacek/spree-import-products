require 'spec_helper'.freeze

describe Imports::ImportProductsFromCsvUseCase do
  subject { described_class.call(params: params) }

  let(:simple_csv) do
    fixture_file_upload("files/spree-products-example.csv", "text/csv")
  end

  let(:wrong_data_in_csv) do
    fixture_file_upload("files/wrong_data.csv", "text/csv")
  end

  let(:product_import) do
    create(:product_import, data_file: set_file, status: "pending")
  end

  before { create(:stock_location) unless Spree::StockLocation.any? }

  let(:params) do
    {
      file: product_import.data_file,
      product_import_id: product_import.id
    }
  end

  context "when product exist in database" do
    let(:set_file) { simple_csv }
    let!(:product) { create(:product, name: "Ruby on Rails Bag") }

    it "does not create duplicate" do
      expect { subject }.not_to change{
        Spree::Product.where(name: product.name).count
      }
    end

    it "sets success status to product import" do
      subject
      expect(product_import.reload.status).to eq("success")
    end
  end

  context "when products does not exist in database" do
    let(:set_file) { simple_csv }

    it { expect { subject }.to change(Spree::Product, :count).by(3) }

    it "sets success status to product import" do
      subject
      expect(product_import.reload.status).to eq("success")
    end
  end

  context "when csv file has wrong data" do
    let(:set_file) { wrong_data_in_csv }

    it { expect { subject }.not_to change(Spree::Product, :count) }

    it "sets failed status to product import" do
      subject
      expect(product_import.reload.status).to eq("failed")
    end

    it "shows errors details for import" do
      subject
      expect(product_import.reload.import_errors).to eq("[{:row_index=>1, :error_info=>{:name=>[\"can't be blank\"]}}]")
    end
  end
end