require 'spec_helper'.freeze

describe Spree::Admin::ProductImportsController, type: :controller do
  let(:simple_csv) do
    fixture_file_upload("files/spree-products-example.csv", "text/csv")
  end

  let(:jpg_file) do
    fixture_file_upload("files/user_image.jpg", "image/jpeg")
  end

  context "when user is authoried" do
    stub_authorization!

    describe "GET #index" do
      it "redirects to the product_imports/new page" do
        spree_get :index

        expect(response).to redirect_to(spree.new_admin_product_import_path)
      end
    end

    describe "GET #new" do
      it 'assigns a new product import as @product_import' do
        spree_get :new

        expect(assigns(:product_import)).to be_a_new Spree::ProductImport
      end
    end

    describe "POST #create" do
      before do
        user = create(:user)
        allow(controller).to receive(:spree_current_user).and_return(user)
      end

      subject do
        post :create, params: {
          product_import: product_import_params
        }
      end

      context "with valid params" do
        let(:product_import_params) do
          {
            "data_file" => simple_csv
          }
        end

        it "creates product import" do
          expect {
            subject
          }.to change(Spree::ProductImport, :count).by(1)
        end

        it "runs job for creating products from csv file" do
          expect(CreateProductsFromCsvJob).to receive(:perform_later).with(an_instance_of(Spree::ProductImport))
          subject
        end

        it "redirects to the products page" do
          subject
          expect(response).to redirect_to(spree.admin_product_import_details_path)
        end
      end

      context "with invalid params" do
        let(:product_import_params) do
          {
            "data_file" => jpg_file
          }
        end

        it "does not create product import" do
          expect {
            subject
          }.to raise_error(
            ActiveRecord::RecordInvalid, "Validation failed: Data file must be a CSV file"
          )
        end
      end
    end

    describe "GET #import_details" do
      let(:record) { create(:product_import, data_file: simple_csv) }

      it "assigns @product_imports" do
        spree_get :import_details

        expect(assigns(:product_imports)).to eq([record])
      end

      it "renders the import details page" do
        spree_get :import_details

        expect(response).to render_template("import_details")
      end
    end
  end

  context "when user is not authorized" do
    describe "GET #index" do
      it "redirects to the rooth path" do
        spree_get :index

        expect(response).to redirect_to(spree.root_path)
      end
    end

    describe "GET #new" do
      it 'assigns a new product import as @product_import' do
        spree_get :new

        expect(response).to redirect_to(spree.root_path)
      end
    end
  end
end