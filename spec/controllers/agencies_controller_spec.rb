require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe AgenciesController, type: :controller do
  let(:valid_attributes) do
    build(:agency).attributes
  end

  let(:invalid_attributes) do
    build(:agency, name: nil, email: nil, number: nil).attributes
  end

  let(:valid_session) {}

  let(:token) { double acceptable?: true }

  before(:each, authorized: true) do
    allow(controller).to receive(:doorkeeper_token) { token }
  end

  describe "Authorised user" do
    describe "GET #index" do
      it "returns a success response", authorized: true do
        Agency.create! valid_attributes
        get :index

        expect(response).to be_success
      end

      it "does not return a deleted agency", authorized: true do
        agency = Agency.create! valid_attributes
        agency.discard
        get :index
        expect(parsed_response).to match([])
        expect(response).to be_success
      end
    end

    describe "GET #show" do
      it "returns a success response", authorized: true do
        agency = Agency.create! valid_attributes
        get :show, params: { id: agency.to_param }
        expect(response).to be_success
      end

      it "returns not found when agency not found", authorized: true do
        get :show, params: { id: 0 }
        expect(response).to be_not_found
      end

      it "returns not found when agency is deleted", authorized: true do
        agency = Agency.create! valid_attributes
        agency.discard
        get :show, params: { id: agency.to_param }
        expect(response).to be_not_found
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new Agency", authorized: true do
          expect do
            post :create, params: { agency: valid_attributes }
          end.to change(Agency, :count).by(1)
        end

        it "renders a JSON response with the new agency", authorized: true do
          post :create, params: { agency: valid_attributes }
          expect(response).to have_http_status(:created)
          expect(response.content_type).to eq('application/json')
          expect(response.location).to eq(agency_url(Agency.last))
        end
      end

      context "with invalid params", authorized: true do
        it "renders a JSON response with errors for the new agency" do
          post :create, params: { agency: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) do
          attributes_for(:agency)
        end

        it "updates the requested agency", authorized: true do
          agency = Agency.create! valid_attributes

          put :update, params: { id: agency.to_param, agency: new_attributes }, session: valid_session
          agency.reload
          expect(agency.name).to eq(new_attributes[:name])
          expect(agency.email).to eq(new_attributes[:email])
          expect(agency.number).to eq(new_attributes[:number])
        end

        it "renders a JSON response with the agency", authorized: true do
          agency = Agency.create! valid_attributes

          put :update, params: { id: agency.to_param, agency: valid_attributes }, session: valid_session
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('application/json')
        end

        it "does not update a deleted agency", authorized: true do
          agency = Agency.create! valid_attributes
          original_agency = agency
          agency.discard
          put :update, params: { id: agency.to_param, agency: new_attributes }, session: valid_session
          agency.reload
          expect(agency.name).to eq(original_agency[:name])
          expect(agency.email).to eq(original_agency[:email])
          expect(agency.number).to eq(original_agency[:number])
        end

        it "returns not found on a deleted agency", authorized: true do
          agency = Agency.create! valid_attributes
          agency.discard
          put :update, params: { id: agency.to_param, agency: new_attributes }, session: valid_session
          agency.reload
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with invalid id" do
        it "renders a JSON response with errors for the agency", authorized: true do
          put :update, params: { id: 0, agency: valid_attributes }, session: valid_session
          expect(response).to be_not_found
        end
      end

      context "with invalid params" do
        it "renders a JSON response with errors for the agency", authorized: true do
          agency = Agency.create! valid_attributes

          put :update, params: { id: agency.to_param, agency: invalid_attributes }, session: valid_session
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    describe "DELETE #destroy" do
      it "soft deletes", authorized: true do
        agency = Agency.create! valid_attributes
        expect do
          delete :destroy, params: { id: agency.to_param }, session: valid_session
        end.to change(Agency, :count).by(0)
      end

      it "sets discarded_at datetime", authorized: true do
        agency = Agency.create! valid_attributes
        delete :destroy, params: { id: agency.to_param }
        agency.reload
        expect(agency.discarded?).to be true
      end

      it "renders a JSON response with the agency", authorized: true do
        agency = Agency.create! valid_attributes

        delete :destroy, params: { id: agency.to_param }
        expect(response).to have_http_status(204)
      end

      it "renders not found when the agency is already deleted", authorized: true do
        agency = Agency.create! valid_attributes
        agency.discard
        delete :destroy, params: { id: agency.to_param }
        expect(response).to have_http_status(404)
      end

      it "returns a not found response when agency not found", authorized: true do
        delete :destroy, params: { id: 0 }
        expect(response).to be_not_found
      end
    end
  end

  describe "Unauthorised user" do
    describe "GET #index" do
      it "returns an unauthorized response", authorized: false do
        Agency.create! valid_attributes
        get :index

        expect_unauthorized
      end
    end

    describe "GET #show" do
      it "returns an unauthorized response", authorized: false do
        agency = Agency.create! valid_attributes
        get :show, params: { id: agency.to_param }

        expect_unauthorized
      end
    end

    describe "POST #create" do
      it "does not create a new Agency", authorized: false do
        expect do
          post :create, params: { agency: valid_attributes }
        end.to change(Agency, :count).by(0)
      end

      it "returns an unauthorized response", authorized: false do
        post :create, params: { agency: valid_attributes }
        expect_unauthorized
      end
    end

    describe "PUT #update" do
      let(:new_attributes) do
        attributes_for(:agency)
      end

      it "does not update the requested agency", authorized: false do
        agency = Agency.create! valid_attributes
        current_attributes = agency.attributes

        put :update, params: { id: agency.to_param, agency: new_attributes }, session: valid_session
        agency.reload
        expect(agency.name).to eq(current_attributes["name"])
        expect(agency.number).to eq(current_attributes["number"])
        expect(agency.email).to eq(current_attributes["email"])
      end

      it "returns an unauthorized response", authorized: false do
        agency = Agency.create! valid_attributes

        put :update, params: { id: agency.to_param, agency: valid_attributes }, session: valid_session
        expect_unauthorized
      end
    end

    describe "DELETE #destroy" do
      it "does not destroy the requested agency", authorized: false do
        agency = Agency.create! valid_attributes
        expect do
          delete :destroy, params: { id: agency.to_param }, session: valid_session
        end.to change(Agency, :count).by(0)
      end

      it "does not set discarded_at datetime", authorized: false do
        agency = Agency.create! valid_attributes
        delete :destroy, params: { id: agency.to_param }
        agency.reload
        expect(agency.discarded?).to be false
      end

      it "returns an unauthorized response", authorized: false do
        agency = Agency.create! valid_attributes

        delete :destroy, params: { id: agency.to_param }, session: valid_session
        expect_unauthorized
      end
    end
  end
end
