require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe AgenciesController, type: :controller do
  let(:valid_attributes) do
    build(:agency_as_params)
  end

  let(:valid_attributes_with_no_image) do
    build(:agency_as_params, image: "")
  end

  let(:valid_agency) do
    create(:agency)
  end

  let(:invalid_attributes) do
    build(:agency_as_params, name: nil, email: nil, phone_number: nil, acronym: nil, description: nil, kind: nil)
  end

  let(:valid_session) {}

  let(:token) { double acceptable?: true }

  before(:each, authorized: true) do
    allow(controller).to receive(:doorkeeper_token) { token }
  end

  describe "Authorised user" do
    describe "GET #index" do
      it "returns a success response", authorized: true do
        valid_agency
        get :index

        expect(response).to be_success
      end

      it "returns 25 result (1 page)", authorized: true do
        default_result_per_page = 25
        num_of_object_to_create = 30
        create_list(:agency, num_of_object_to_create)

        get :index
        expect(JSON.parse(response.body).count).to match default_result_per_page
      end

      it "does not return a deleted agency", authorized: true do
        valid_agency.discard
        get :index
        expect(parsed_response).to match([])
        expect(response).to be_success
      end
    end

    describe "GET #show" do
      it "returns a success response", authorized: true do
        get :show, params: { id: valid_agency.to_param }
        expect(response).to be_success
      end

      it "returns not found when agency not found", authorized: true do
        get :show, params: { id: 0 }
        expect(response).to be_not_found
      end

      it "returns not found when agency is deleted", authorized: true do
        valid_agency.discard
        get :show, params: { id: valid_agency.to_param }
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

        it "creates a letterhead avatar when no image is specified", authorized: true do
          post :create, params: { agency: valid_attributes_with_no_image }
          expect(parsed_response[:image][:url]).to_not eq(nil)
          expect(parsed_response[:image][:thumb][:url]).to_not eq(nil)
        end

        it "creates a image", authorized: true do
          post :create, params: { agency: valid_attributes }
          expect(parsed_response[:image][:url]).to_not eq(nil)
          expect(parsed_response[:image][:thumb][:url]).to_not eq(nil)
        end
      end

      context "with invalid params", authorized: true do
        it "renders a JSON response with errors for the new agency" do
          post :create, params: { agency: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end

        it "returns 422 when the image is invalid", authorized: true do
          valid_attributes[:image] = partial_base64_image
          post :create, params: { agency: valid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        it "updates the requested agency", authorized: true do
          put :update, params: { id: valid_agency.to_param, agency: valid_attributes }, session: valid_session
          valid_agency.reload
          expect(valid_agency.name).to eq(valid_attributes[:name])
          expect(valid_agency.email).to eq(valid_attributes[:email])
          expect(valid_agency.phone_number).to eq(valid_attributes[:phone_number])
          expect(valid_agency.acronym).to eq(valid_attributes[:acronym])
          expect(valid_agency.kind).to eq(valid_attributes[:kind])
          expect(valid_agency.description).to eq(valid_attributes[:description])
        end

        it "renders a JSON response with the agency", authorized: true do
          put :update, params: { id: valid_agency.to_param, agency: valid_attributes }, session: valid_session
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('application/json')
        end

        it "does not update a deleted agency", authorized: true do
          original_agency = valid_agency.attributes.with_indifferent_access
          valid_agency.discard
          put :update, params: { id: valid_agency.to_param, agency: valid_attributes }, session: valid_session
          valid_agency.reload
          expect(valid_agency.name).to eq(original_agency[:name])
          expect(valid_agency.email).to eq(original_agency[:email])
          expect(valid_agency.phone_number).to eq(original_agency[:phone_number])
          expect(valid_agency.acronym).to eq(original_agency[:acronym])
          expect(valid_agency.kind).to eq(original_agency[:kind])
          expect(valid_agency.description).to eq(original_agency[:description])
        end

        it "returns not found on a deleted agency", authorized: true do
          valid_agency.discard
          put :update, params: { id: valid_agency.to_param, agency: valid_attributes }, session: valid_session
          valid_agency.reload
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with invalid id" do
        it "renders a JSON response with errors for the agency", authorized: true do
          put :update, params: { id: 0, agency: valid_attributes }, session: valid_session
          expect(response).to be_not_found
        end

        it "updates a image", authorized: true do
          original_agency = create(:agency)
          patch :update, params: { agency: valid_attributes, id: original_agency.id }
          original_agency.reload
          expect(parsed_response[:image]).to_not eq(original_agency.image.serializable_hash)
        end
      end

      context "with invalid params" do
        it "renders a JSON response with errors for the agency", authorized: true do
          put :update, params: { id: valid_agency.to_param, agency: invalid_attributes }, session: valid_session
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end

        it "returns 422 when the image is invalid", authorized: true do
          original_agency = create(:agency)
          valid_attributes[:image] = partial_base64_image
          patch :update, params: { agency: valid_attributes, id: original_agency.hashid }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    describe "DELETE #destroy" do
      it "soft deletes", authorized: true do
        valid_agency
        expect do
          delete :destroy, params: { id: valid_agency.to_param }, session: valid_session
        end.to change(Agency, :count).by(0)
      end

      it "sets discarded_at datetime", authorized: true do
        delete :destroy, params: { id: valid_agency.to_param }
        valid_agency.reload
        expect(valid_agency.discarded?).to be true
      end

      it "renders a JSON response with the agency", authorized: true do
        delete :destroy, params: { id: valid_agency.to_param }
        expect(response).to have_http_status(204)
      end

      it "renders not found when the agency is already deleted", authorized: true do
        valid_agency.discard
        delete :destroy, params: { id: valid_agency.to_param }
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
        valid_agency
        get :index

        expect_unauthorized
      end
    end

    describe "GET #show" do
      it "returns an unauthorized response", authorized: false do
        valid_agency
        get :show, params: { id: valid_agency.to_param }

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
        current_attributes = valid_agency.attributes

        put :update, params: { id: valid_agency.to_param, agency: valid_attributes }, session: valid_session
        valid_agency.reload
        expect(valid_agency.name).to eq(current_attributes["name"])
        expect(valid_agency.phone_number).to eq(current_attributes["phone_number"])
        expect(valid_agency.email).to eq(current_attributes["email"])
      end

      it "returns an unauthorized response", authorized: false do
        put :update, params: { id: valid_agency.to_param, agency: valid_attributes }, session: valid_session
        expect_unauthorized
      end
    end

    describe "DELETE #destroy" do
      it "does not destroy the requested agency", authorized: false do
        valid_agency
        expect do
          delete :destroy, params: { id: valid_agency.to_param }, session: valid_session
        end.to change(Agency, :count).by(0)
      end

      it "does not set discarded_at datetime", authorized: false do
        delete :destroy, params: { id: valid_agency.to_param }
        valid_agency.reload
        expect(valid_agency.discarded?).to be false
      end

      it "returns an unauthorized response", authorized: false do
        delete :destroy, params: { id: valid_agency.to_param }, session: valid_session
        expect_unauthorized
      end
    end
  end
end
