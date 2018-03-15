require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe "Agencies", type: :request do
  let(:valid_attributes) do
    build(:agency).attributes
  end

  let(:invalid_attributes) do
    build(:agency, name: nil, email: nil, number: nil).attributes
  end

  describe "Authorised user" do
    describe "GET /api/v1/agencies" do
      it "returns a success response" do
        Agency.create! valid_attributes
        get agencies_path, headers: request_login

        expect(response).to be_success
      end

      it "does not return a deleted agency", authorized: true do
        agency = Agency.create! valid_attributes
        agency.discard
        get agencies_path, headers: request_login
        expect(parsed_response).to match([])
        expect(response).to be_success
      end
    end

    describe "GET /api/v1/agencies/:id" do
      it "returns a success response" do
        agency = Agency.create! valid_attributes
        get agency_path(agency.to_param), headers: request_login
        expect(response).to be_success
      end

      it "returns not found when agency not found" do
        get agency_path(0), headers: request_login
        expect(response).to be_not_found
      end

      it "returns not found when agency is deleted", authorized: true do
        agency = Agency.create! valid_attributes
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
        let(:new_attributes) do
          attributes_for(:agency)
        end

        it "updates the requested agency" do
          agency = Agency.create! valid_attributes

          put agency_path(agency.id), params: { agency: new_attributes }, headers: request_login
          agency.reload
          expect(agency.name).to eq(new_attributes[:name])
          expect(agency.email).to eq(new_attributes[:email])
          expect(agency.number).to eq(new_attributes[:number])
          expect(agency.acronym).to eq(new_attributes[:acronym])
          expect(agency.kind).to eq(new_attributes[:kind])
          expect(agency.description).to eq(new_attributes[:description])
        end

        it "renders a JSON response with the agency" do
          agency = Agency.create! valid_attributes

          put agency_path(agency.id), params: { agency: new_attributes }, headers: request_login
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('application/json')
        end

        it "does not update a deleted agency", authorized: true do
          agency = Agency.create! valid_attributes
          original_agency = agency
          agency.discard
          put agency_path(agency.id), params: { agency: new_attributes }, headers: request_login
          agency.reload
          expect(agency.name).to eq(original_agency[:name])
          expect(agency.email).to eq(original_agency[:email])
          expect(agency.number).to eq(original_agency[:number])
          expect(agency.acronym).to eq(original_agency[:acronym])
          expect(agency.kind).to eq(original_agency[:kind])
          expect(agency.description).to eq(original_agency[:description])
        end

        it "returns not found on a deleted agency", authorized: true do
          agency = Agency.create! valid_attributes
          agency.discard
          put agency_path(agency.id), params: { agency: new_attributes }, headers: request_login
          agency.reload
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with invalid id" do
        it "renders a JSON response with errors for the agency" do
          put agency_path(0), params: { agency: attributes_for(:agency) }, headers: request_login
          expect(response).to be_not_found
        end
      end

      context "with invalid params" do
        it "renders a JSON response with errors for the agency" do
          agency = Agency.create! valid_attributes

          put agency_path(agency.id), params: { agency: invalid_attributes }, headers: request_login
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    describe "DELETE #destroy" do
      it "soft deletes" do
        agency = Agency.create! valid_attributes
        expect do
          delete agency_path(agency.id), headers: request_login
        end.to change(Agency, :count).by(0)
      end

      it "sets discarded_at datetime" do
        agency = Agency.create! valid_attributes
        delete agency_path(agency.id), headers: request_login
        agency.reload
        expect(agency.discarded?).to be true
      end

      it "renders a JSON response with the agency" do
        agency = Agency.create! valid_attributes

        delete agency_path(agency.id), headers: request_login
        expect(response).to have_http_status(204)
      end

      it "returns a not found response when agency not found" do
        delete agency_path(0), headers: request_login
        expect(response).to be_not_found
      end

      it "renders not found when the agency is already deleted", authorized: true do
        agency = Agency.create! valid_attributes
        agency.discard
        delete agency_path(agency.id), headers: request_login
        expect(response).to have_http_status(404)
      end
    end
  end

  describe "Unauthorised user" do
    describe "GET #index" do
      it "returns an unauthorized response" do
        Agency.create! valid_attributes
        get agencies_path, headers: nil

        expect_unauthorized
      end
    end

    describe "GET #show" do
      it "returns an unauthorized response" do
        agency = Agency.create! valid_attributes
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
      let(:new_attributes) do
        attributes_for(:agency)
      end

      it "does not update the requested agency" do
        agency = Agency.create! valid_attributes
        current_attributes = agency.attributes

        put agency_path(agency.id), params: { agency: new_attributes }, headers: nil
        agency.reload
        expect(agency.name).to eq(current_attributes["name"])
        expect(agency.number).to eq(current_attributes["number"])
        expect(agency.email).to eq(current_attributes["email"])
      end

      it "returns an unauthorized response" do
        agency = Agency.create! valid_attributes

        put agency_path(agency.id), params: { agency: valid_attributes }, headers: nil
        expect_unauthorized
      end
    end

    describe "DELETE #destroy" do
      it "does not destroy the requested agency" do
        agency = Agency.create! valid_attributes
        expect do
          delete agency_path(agency.id), headers: nil
        end.to change(Agency, :count).by(0)
      end

      it "does not set discarded_at datetime" do
        agency = Agency.create! valid_attributes
        delete agency_path(agency.id), headers: nil
        agency.reload
        expect(agency.discarded?).to be false
      end

      it "returns an unauthorized response" do
        agency = Agency.create! valid_attributes

        delete agency_path(agency.id), headers: nil
        expect_unauthorized
      end
    end
  end
end
