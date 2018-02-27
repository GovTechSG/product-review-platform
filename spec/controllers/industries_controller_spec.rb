require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe IndustriesController, type: :controller do
  let(:valid_attributes) do
    build(:industry).attributes
  end

  let(:invalid_attributes) do
    build(:industry, name: nil).attributes
  end

  let(:token) { double acceptable?: true }

  before(:each, authorized: true) do
    allow(controller).to receive(:doorkeeper_token) { token }
  end

  describe "Authorised user" do
    describe "GET #index" do
      it "returns a success response", authorized: true do
        Industry.create! valid_attributes
        get :index

        expect(response).to be_success
      end
    end

    describe "GET #show" do
      it "returns a success response", authorized: true do
        industry = Industry.create! valid_attributes
        get :show, params: { id: industry.to_param }
        expect(response).to be_success
      end

      it "returns not found when industry not found", authorized: true do
        get :show, params: { id: 0 }
        expect(response).to be_not_found
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new Industry", authorized: true do
          expect do
            post :create, params: { industry: valid_attributes }
          end.to change(Industry, :count).by(1)
        end

        it "renders a JSON response with the new industry", authorized: true do
          post :create, params: { industry: valid_attributes }
          expect(response).to have_http_status(:created)
          expect(response.content_type).to eq('application/json')
          expect(response.location).to eq(industry_url(Industry.last))
        end
      end

      context "with invalid params", authorized: true do
        it "renders a JSON response with errors for the new industry" do
          post :create, params: { industry: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end

        it "renders a 422 error for duplicate names", authorized: true do
          valid_industry = valid_attributes
          Industry.create! valid_industry

          post :create, params: { industry: valid_industry }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) do
          attributes_for(:industry)
        end

        it "updates the requested industry", authorized: true do
          industry = Industry.create! valid_attributes

          put :update, params: { id: industry.to_param, industry: new_attributes }
          industry.reload
          expect(industry.name).to eq(new_attributes[:name])
        end

        it "renders a JSON response with the industry", authorized: true do
          industry = Industry.create! valid_attributes

          put :update, params: { id: industry.to_param, industry: valid_attributes }
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with invalid params" do
        it "renders a JSON response with errors for the industry", authorized: true do
          industry = Industry.create! valid_attributes

          put :update, params: { id: industry.to_param, industry: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end

        it "renders a 422 error for duplicate names", authorized: true do
          industry = Industry.create! valid_attributes
          another_industry = create(:industry)
          put :update, params: { id: industry.to_param, industry: attributes_for(:industry, name: another_industry.name) }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    describe "DELETE #destroy" do
      it "soft deletes", authorized: true do
        industry = Industry.create! valid_attributes
        expect do
          delete :destroy, params: { id: industry.to_param }
        end.to change(Industry, :count).by(0)
      end

      it "sets discarded_at datetime", authorized: true do
        industry = Industry.create! valid_attributes
        delete :destroy, params: { id: industry.to_param }
        industry.reload
        expect(industry.discarded?).to be true
      end

      it "renders a JSON response with the industry", authorized: true do
        industry = Industry.create! valid_attributes

        delete :destroy, params: { id: industry.to_param }
        expect(response).to have_http_status(204)
      end

      it "returns a not found response when industry not found", authorized: true do
        delete :destroy, params: { id: 0 }
        expect(response).to be_not_found
      end
    end
  end

  describe "Unauthorised user" do
    describe "GET #index" do
      it "returns an unauthorized response", authorized: false do
        Industry.create! valid_attributes
        get :index

        expect_unauthorized
      end
    end

    describe "GET #show" do
      it "returns an unauthorized response", authorized: false do
        industry = Industry.create! valid_attributes
        get :show, params: { id: industry.to_param }

        expect_unauthorized
      end
    end

    describe "POST #create" do
      it "does not create a new Industry", authorized: false do
        expect do
          post :create, params: { industry: valid_attributes }
        end.to change(Industry, :count).by(0)
      end

      it "returns an unauthorized response", authorized: false do
        post :create, params: { industry: valid_attributes }
        expect_unauthorized
      end
    end

    describe "PUT #update" do
      let(:new_attributes) do
        attributes_for(:industry)
      end

      it "does not update the requested industry", authorized: false do
        industry = Industry.create! valid_attributes
        current_attributes = industry.attributes

        put :update, params: { id: industry.to_param, industry: new_attributes }
        industry.reload
        expect(industry.name).to eq(current_attributes["name"])
      end

      it "returns an unauthorized response", authorized: false do
        industry = Industry.create! valid_attributes

        put :update, params: { id: industry.to_param, industry: valid_attributes }
        expect_unauthorized
      end
    end

    describe "DELETE #destroy" do
      it "does not destroy the requested industry", authorized: false do
        industry = Industry.create! valid_attributes
        expect do
          delete :destroy, params: { id: industry.to_param }
        end.to change(Industry, :count).by(0)
      end

      it "does not set discarded_at datetime", authorized: false do
        industry = Industry.create! valid_attributes
        delete :destroy, params: { id: industry.to_param }
        industry.reload
        expect(industry.discarded?).to be false
      end

      it "returns an unauthorized response", authorized: false do
        industry = Industry.create! valid_attributes

        delete :destroy, params: { id: industry.to_param }
        expect_unauthorized
      end
    end
  end
end
