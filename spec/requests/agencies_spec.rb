require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe "Agencies", type: :request do
  let(:valid_attributes) do
    build(:agency_as_params)
  end

  let(:valid_attributes_with_no_image) do
    build(:agency_as_params, image: "")
  end

  let(:invalid_attributes) do
    build(:agency_as_params, name: nil, email: nil, phone_number: nil)
  end

  let(:agency) do
    create(:agency)
  end

  describe "Authorised user" do
    describe "GET /api/v1/agencies" do
      it "returns a success response" do
        agency
        get agencies_path, headers: request_login

        expect(response).to be_success
      end

      it "does not return a deleted agency", authorized: true do
        agency.discard
        get agencies_path, headers: request_login
        expect(parsed_response).to match([])
        expect(response).to be_success
      end
    end

    describe "GET /api/v1/agencies/:id" do
      it "returns a success response" do
        get agency_path(agency.to_param), headers: request_login
        expect(response).to be_success
      end

      it "returns not found when agency not found" do
        get agency_path(0), headers: request_login
        expect(response).to be_not_found
      end

      it "returns not found when agency is deleted", authorized: true do
        agency.discard
        get agency_path(agency.id), headers: request_login
        expect(response).to be_not_found
      end
    end

    describe "POST api/v1/agencies" do
      context "with valid params" do
        it "creates a new Agency" do
          expect do
            post agencies_path, params: { agency: valid_attributes }, headers: request_login
          end.to change(Agency, :count).by(1)
        end

        it "renders a JSON response with the new agency" do
          post agencies_path, params: { agency: valid_attributes }, headers: request_login
          expect(response).to have_http_status(:created)
          expect(response.content_type).to eq('application/json')
          expect(response.location).to eq(agency_url(Agency.last))
        end
      end

      context "with invalid params" do
        it "renders a JSON response with errors for the new agency" do
          post agencies_path, params: { agency: invalid_attributes }, headers: request_login
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    describe "PUT api/v1/agencies/id" do
      context "with valid params" do
        it "updates the requested agency" do
          put agency_path(agency.id), params: { agency: valid_attributes }, headers: request_login
          agency.reload
          expect(agency.name).to eq(valid_attributes[:name])
          expect(agency.email).to eq(valid_attributes[:email])
          expect(agency.phone_number).to eq(valid_attributes[:phone_number])
          expect(agency.acronym).to eq(valid_attributes[:acronym])
          expect(agency.kind).to eq(valid_attributes[:kind])
          expect(agency.description).to eq(valid_attributes[:description])
        end

        it "renders a JSON response with the agency" do
          put agency_path(agency.id), params: { agency: valid_attributes }, headers: request_login
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('application/json')
        end

        it "does not update a deleted agency", authorized: true do
          original_agency = agency.attributes.with_indifferent_access
          agency.discard
          put agency_path(agency.id), params: { agency: valid_attributes }, headers: request_login
          agency.reload
          expect(agency.name).to eq(original_agency[:name])
          expect(agency.email).to eq(original_agency[:email])
          expect(agency.phone_number).to eq(original_agency[:phone_number])
          expect(agency.acronym).to eq(original_agency[:acronym])
          expect(agency.kind).to eq(original_agency[:kind])
          expect(agency.description).to eq(original_agency[:description])
        end

        it "returns not found on a deleted agency", authorized: true do
          agency.discard
          put agency_path(agency.id), params: { agency: valid_attributes }, headers: request_login
          agency.reload
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with invalid id" do
        it "renders a JSON response with errors for the agency" do
          put agency_path(0), params: { agency: valid_attributes }, headers: request_login
          expect(response).to be_not_found
        end
      end

      context "with invalid params" do
        it "renders a JSON response with errors for the agency" do
          put agency_path(agency.id), params: { agency: invalid_attributes }, headers: request_login
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    describe "DELETE #destroy" do
      it "soft deletes" do
        agency
        expect do
          delete agency_path(agency.id), headers: request_login
        end.to change(Agency, :count).by(0)
      end

      it "sets discarded_at datetime" do
        delete agency_path(agency.id), headers: request_login
        agency.reload
        expect(agency.discarded?).to be true
      end

      it "renders a JSON response with the agency" do
        delete agency_path(agency.id), headers: request_login
        expect(response).to have_http_status(204)
      end

      it "returns a not found response when agency not found" do
        delete agency_path(0), headers: request_login
        expect(response).to be_not_found
      end

      it "renders not found when the agency is already deleted", authorized: true do
        agency.discard
        delete agency_path(agency.id), headers: request_login
        expect(response).to have_http_status(404)
      end
    end
  end

  describe "Unauthorised user" do
    describe "GET #index" do
      it "returns an unauthorized response" do
        get agencies_path, headers: nil

        expect_unauthorized
      end
    end

    describe "GET #show" do
      it "returns an unauthorized response" do
        get agency_path(agency.id), headers: nil

        expect_unauthorized
      end
    end

    describe "POST #create" do
      it "does not create a new Agency" do
        expect do
          post agencies_path, params: { agency: valid_attributes }, headers: nil
        end.to change(Agency, :count).by(0)
      end

      it "returns an unauthorized response" do
        post agencies_path, params: { agency: valid_attributes }, headers: nil
        expect_unauthorized
      end
    end

    describe "PUT #update" do
      let(:valid_attributes) do
        attributes_for(:agency)
      end

      it "does not update the requested agency" do
        current_attributes = agency.attributes.with_indifferent_access

        put agency_path(agency.id), params: { agency: valid_attributes }, headers: nil
        agency.reload
        expect(agency.name).to eq(current_attributes["name"])
        expect(agency.phone_number).to eq(current_attributes["phone_number"])
        expect(agency.email).to eq(current_attributes["email"])
      end

      it "returns an unauthorized response" do
        put agency_path(agency.id), params: { agency: valid_attributes }, headers: nil
        expect_unauthorized
      end
    end

    describe "DELETE #destroy" do
      it "does not destroy the requested agency" do
        agency
        expect do
          delete agency_path(agency.id), headers: nil
        end.to change(Agency, :count).by(0)
      end

      it "does not set discarded_at datetime" do
        delete agency_path(agency.id), headers: nil
        agency.reload
        expect(agency.discarded?).to be false
      end

      it "returns an unauthorized response" do
        delete agency_path(agency.id), headers: nil
        expect_unauthorized
      end
    end
  end
end
