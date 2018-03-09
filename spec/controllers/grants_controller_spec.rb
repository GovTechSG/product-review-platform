require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe GrantsController, type: :controller do
  let(:valid_attributes) do
    build(:grant).attributes
  end

  let(:invalid_attributes) do
    attributes_for(:grant, name: nil, acronym: nil, user_id: nil)
  end

  let(:token) { double acceptable?: true }

  before(:each, authorized: true) do
    allow(controller).to receive(:doorkeeper_token) { token }
  end

  describe "Authorised user" do
    describe "GET #index" do
      it "returns a success response", authorized: true do
        Grant.create! valid_attributes
        get :index

        expect(response).to be_success
      end
    end

    describe "GET #show" do
      it "returns a success response", authorized: true do
        grant = Grant.create! valid_attributes
        get :show, params: { id: grant.to_param }
        expect(response).to be_success
      end

      it "returns not found when grant is deleted", authorized: true do
        grant = Grant.create! valid_attributes
        grant.discard
        get :show, params: { id: grant.to_param }
        expect(response.status).to eq(404)
      end

      it "returns not found when grant not found", authorized: true do
        get :show, params: { id: 0 }
        expect(response).to be_not_found
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new Grant", authorized: true do
          expect do
            post :create, params: { grant: valid_attributes }
          end.to change(Grant, :count).by(1)
        end

        it "renders a JSON response with the new grant", authorized: true do
          post :create, params: { grant: valid_attributes }
          expect(response).to have_http_status(:created)
          expect(response.content_type).to eq('application/json')
          expect(response.location).to eq(grant_url(Grant.last))
        end
      end

      context "with invalid params", authorized: true do
        it "renders a JSON response with errors for the new grant" do
          post :create, params: { grant: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end

        it "renders a 422 error for duplicate names", authorized: true do
          valid_grant = valid_attributes
          Grant.create! valid_grant

          post :create, params: { grant: valid_grant }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) do
          attributes_for(:grant)
        end

        it "updates the requested grant", authorized: true do
          grant = Grant.create! valid_attributes

          put :update, params: { id: grant.to_param, grant: new_attributes }
          grant.reload
          expect(grant.name).to eq(new_attributes[:name])
          expect(grant.description).to eq(new_attributes[:description])
          expect(grant.acronym).to eq(new_attributes[:acronym])
        end

        it "renders a JSON response with the grant", authorized: true do
          grant = Grant.create! valid_attributes

          put :update, params: { id: grant.to_param, grant: valid_attributes }
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with deleted grant" do
        let(:new_attributes) do
          attributes_for(:grant)
        end

        it "does not updates the requested grant", authorized: true do
          grant = Grant.create! valid_attributes
          original_grant = grant
          grant.discard
          put :update, params: { id: grant.to_param, grant: new_attributes }
          grant.reload
          expect(grant.name).to eq(original_grant[:name])
          expect(grant.description).to eq(original_grant[:description])
          expect(grant.acronym).to eq(original_grant[:acronym])
        end

        it "renders a not found response", authorized: true do
          grant = Grant.create! valid_attributes
          grant.discard
          put :update, params: { id: grant.to_param, grant: valid_attributes }
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with invalid params" do
        it "renders a JSON response with errors for the grant", authorized: true do
          grant = Grant.create! valid_attributes

          put :update, params: { id: grant.to_param, grant: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end

        it "renders a 422 error for duplicate names", authorized: true do
          grant = Grant.create! valid_attributes
          another_grant = create(:grant)
          put :update, params: { id: grant.to_param, grant: attributes_for(:grant, name: another_grant.name) }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end

        it "does not updates the requested grant", authorized: true do
          grant = Grant.create! valid_attributes
          original_grant = grant

          put :update, params: { id: grant.to_param, grant: invalid_attributes }
          grant.reload
          expect(grant.name).to eq(original_grant[:name])
          expect(grant.description).to eq(original_grant[:description])
          expect(grant.acronym).to eq(original_grant[:acronym])
        end
      end
    end

    describe "DELETE #destroy" do
      it "soft deletes", authorized: true do
        grant = Grant.create! valid_attributes
        expect do
          delete :destroy, params: { id: grant.to_param }
        end.to change(Grant, :count).by(0)
      end

      it "sets discarded_at datetime", authorized: true do
        grant = Grant.create! valid_attributes
        delete :destroy, params: { id: grant.to_param }
        grant.reload
        expect(grant.discarded?).to be true
      end

      it "renders a JSON response with the grant", authorized: true do
        grant = Grant.create! valid_attributes

        delete :destroy, params: { id: grant.to_param }
        expect(response).to have_http_status(204)
      end

      it "renders a not found JSON response when the grant is deleted", authorized: true do
        grant = Grant.create! valid_attributes
        grant.discard
        delete :destroy, params: { id: grant.to_param }
        expect(response).to have_http_status(404)
      end

      it "returns a not found response when grant not found", authorized: true do
        delete :destroy, params: { id: 0 }
        expect(response).to be_not_found
      end
    end
  end

  describe "Unauthorised user" do
    describe "GET #index" do
      it "returns an unauthorized response", authorized: false do
        Grant.create! valid_attributes
        get :index

        expect_unauthorized
      end
    end

    describe "GET #show" do
      it "returns an unauthorized response", authorized: false do
        grant = Grant.create! valid_attributes
        get :show, params: { id: grant.to_param }

        expect_unauthorized
      end
    end

    describe "POST #create" do
      it "does not create a new Grant", authorized: false do
        expect do
          post :create, params: { grant: valid_attributes }
        end.to change(Grant, :count).by(0)
      end

      it "returns an unauthorized response", authorized: false do
        post :create, params: { grant: valid_attributes }
        expect_unauthorized
      end
    end

    describe "PUT #update" do
      let(:new_attributes) do
        attributes_for(:grant)
      end

      it "does not update the requested grant", authorized: false do
        grant = Grant.create! valid_attributes
        current_attributes = grant.attributes

        put :update, params: { id: grant.to_param, grant: new_attributes }
        grant.reload
        expect(grant.name).to eq(current_attributes["name"])
        expect(grant.description).to eq(current_attributes["description"])
        expect(grant.acronym).to eq(current_attributes["acronym"])
      end

      it "returns an unauthorized response", authorized: false do
        grant = Grant.create! valid_attributes

        put :update, params: { id: grant.to_param, grant: valid_attributes }
        expect_unauthorized
      end
    end

    describe "DELETE #destroy" do
      it "does not destroy the requested grant", authorized: false do
        grant = Grant.create! valid_attributes
        expect do
          delete :destroy, params: { id: grant.to_param }
        end.to change(Grant, :count).by(0)
      end

      it "does not set discarded_at datetime", authorized: false do
        grant = Grant.create! valid_attributes
        delete :destroy, params: { id: grant.to_param }
        grant.reload
        expect(grant.discarded?).to be false
      end

      it "returns an unauthorized response", authorized: false do
        grant = Grant.create! valid_attributes

        delete :destroy, params: { id: grant.to_param }
        expect_unauthorized
      end
    end
  end
end