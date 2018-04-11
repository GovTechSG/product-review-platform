require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe "Industries", type: :request do
  let(:valid_attributes) do
    build(:industry).attributes
  end

  let(:invalid_attributes) do
    build(:industry, name: nil).attributes
  end

  describe "Authorised user" do
    describe "GET /api/v1/industries" do
      it "returns a success response" do
        Industry.create! valid_attributes
        get industries_path, headers: request_login

        expect(response).to be_success
      end
    end

    describe "GET /api/v1/industries/:id" do
      it "returns a success response" do
        industry = Industry.create! valid_attributes
        get industry_path(industry.hashid), headers: request_login
        expect(response).to be_success
      end

      it "returns not found when industry is deleted", authorized: true do
        industry = Industry.create! valid_attributes
        industry.discard
        get industry_path(industry.id), headers: request_login
        expect(response.status).to eq(404)
      end

      it "returns not found when industry not found" do
        get industry_path(0), headers: request_login
        expect(response).to be_not_found
      end
    end

    describe "POST /api/v1/industries" do
      context "with valid params" do
        it "creates a new Industry" do
          expect do
            post industries_path, params: { industry: valid_attributes }, headers: request_login
          end.to change(Industry, :count).by(1)
        end

        it "renders a JSON response with the new industry" do
          post industries_path, params: { industry: valid_attributes }, headers: request_login
          expect(response).to have_http_status(:created)
          expect(response.content_type).to eq('application/json')
          expect(response.location).to eq(industry_url(Industry.last))
        end
      end

      context "with invalid params" do
        it "renders a JSON response with errors for the new industry" do
          post industries_path, params: { industry: invalid_attributes }, headers: request_login
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end

        it "renders a 422 error for duplicate names" do
          valid_industry = valid_attributes
          Industry.create! valid_industry

          post industries_path, params: { industry: valid_industry }, headers: request_login
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

        it "updates the requested industry" do
          industry = Industry.create! valid_attributes

          put industry_path(industry.hashid), params: { industry: new_attributes }, headers: request_login
          industry.reload
          expect(industry.name).to eq(new_attributes[:name])
        end

        it "renders a JSON response with the industry" do
          industry = Industry.create! valid_attributes

          put industry_path(industry.hashid), params: { industry: new_attributes }, headers: request_login
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with deleted industry" do
        let(:new_attributes) do
          attributes_for(:industry)
        end

        it "does not updates the requested industry", authorized: true do
          industry = Industry.create! valid_attributes
          original_industry = industry
          industry.discard
          put industry_path(industry.id), params: { industry: new_attributes }, headers: request_login
          industry.reload
          expect(industry.name).to eq(original_industry[:name])
        end

        it "renders a not found response", authorized: true do
          industry = Industry.create! valid_attributes
          industry.discard
          put industry_path(industry.id), params: { industry: new_attributes }, headers: request_login
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with invalid params" do
        it "renders a JSON response with errors for the industry" do
          industry = Industry.create! valid_attributes

          put industry_path(industry.hashid), params: { industry: invalid_attributes }, headers: request_login
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end

        it "renders a 422 error for duplicate names" do
          industry = Industry.create! valid_attributes
          another_industry = create(:industry)
          put industry_path(industry.hashid), params: { industry: attributes_for(:industry, name: another_industry.name) }, headers: request_login
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    describe "DELETE #destroy" do
      it "soft deletes" do
        industry = Industry.create! valid_attributes
        expect do
          delete industry_path(industry.id), headers: request_login
        end.to change(Industry, :count).by(0)
      end

      it "sets discarded_at datetime" do
        industry = Industry.create! valid_attributes
        delete industry_path(industry.hashid), headers: request_login
        industry.reload
        expect(industry.discarded?).to be true
      end

      it "renders a not found JSON response when the industry is deleted", authorized: true do
        industry = Industry.create! valid_attributes
        industry.discard
        delete industry_path(industry.hashid), headers: request_login
        expect(response).to have_http_status(404)
      end

      it "renders a JSON response with the industry" do
        industry = Industry.create! valid_attributes

        delete industry_path(industry.hashid), headers: request_login
        expect(response).to have_http_status(204)
      end

      it "returns a not found response when industry not found" do
        delete industry_path(0), headers: request_login
        expect(response).to be_not_found
      end
    end
  end

  describe "Unauthorised user" do
    describe "GET #index" do
      it "returns an unauthorized response" do
        Industry.create! valid_attributes
        get industries_path

        expect_unauthorized
      end
    end

    describe "GET #show" do
      it "returns an unauthorized response" do
        industry = Industry.create! valid_attributes
        get industry_path(industry.id)

        expect_unauthorized
      end
    end

    describe "POST #create" do
      it "does not create a new Industry" do
        expect do
          post industries_path, params: { industry: valid_attributes }
        end.to change(Industry, :count).by(0)
      end

      it "returns an unauthorized response" do
        post industries_path, params: { industry: valid_attributes }
        expect_unauthorized
      end
    end

    describe "PUT #update" do
      let(:new_attributes) do
        attributes_for(:industry)
      end

      it "does not update the requested industry" do
        industry = Industry.create! valid_attributes
        current_attributes = industry.attributes

        put industry_path(industry.id), params: { industry: new_attributes }
        industry.reload
        expect(industry.name).to eq(current_attributes["name"])
      end

      it "returns an unauthorized response" do
        industry = Industry.create! valid_attributes

        put industry_path(industry.id), params: { industry: new_attributes }
        expect_unauthorized
      end
    end

    describe "DELETE #destroy" do
      it "does not destroy the requested industry" do
        industry = Industry.create! valid_attributes
        expect do
          delete industry_path(industry.id)
        end.to change(Industry, :count).by(0)
      end

      it "does not set discarded_at datetime" do
        industry = Industry.create! valid_attributes
        delete industry_path(industry.id)
        industry.reload
        expect(industry.discarded?).to be false
      end

      it "returns an unauthorized response" do
        industry = Industry.create! valid_attributes

        delete industry_path(industry.id)
        expect_unauthorized
      end
    end
  end
end
