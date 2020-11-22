require 'spec_helper'.freeze

describe CreateProductsFromCsvJob, type: :job do
  subject { described_class.new.perform(product_import) }

  let(:simple_csv) do
    fixture_file_upload("files/spree-products-example.csv", "text/csv")
  end

  describe "#perform_later" do
    context "when valid params" do
      let(:product_import) { create(:product_import, data_file: simple_csv) }

      it "runs use case to import products from csv file" do
        expect(Imports::ImportProductsFromCsvUseCase).to receive(:call).with(
          params: {
            file: product_import.data_file,
            product_import_id: product_import.id
          }
        )
        subject
      end
    end

    context "when product import does ot exist" do
      let(:product_import) { create(:product_import, data_file: nil) }

      it "does not run use case" do
        expect(Imports::ImportProductsFromCsvUseCase).not_to receive(:call)
        subject
      end
    end
  end
end