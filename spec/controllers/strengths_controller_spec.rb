require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe StrengthsController, type: :controller do
  let(:valid_attributes) do
    build(:strength).attributes
  end

  let(:invalid_attributes) do
    attributes_for(:strength, name: nil, description: nil)
  end

  let(:token) { double acceptable?: true }

  before(:each, authorized: true) do
    allow(controller).to receive(:doorkeeper_token) { token }
  end

  describe "Authorised user" do
    describe "GET #index" do
      it "returns a success response", authorized: true do
        Strength.create! valid_attributes
        get :index

        expect(response).to be_success
      end

      it "returns 25 result (1 page)", authorized: true do
        default_result_per_page = 25
        num_of_object_to_create = 30
        create_list(:strength, num_of_object_to_create)

        get :index
        expect(JSON.parse(response.body).count).to match default_result_per_page
      end
    end

    describe "GET #show" do
      it "returns a success response", authorized: true do
        strength = Strength.create! valid_attributes
        get :show, params: { id: strength.to_param }
        expect(response).to be_success
      end

      it "returns not found when strength is deleted", authorized: true do
        strength = Strength.create! valid_attributes
        strength.discard
        get :show, params: { id: strength.to_param }
        expect(response.status).to eq(404)
      end

      it "returns not found when strength not found", authorized: true do
        get :show, params: { id: 0 }
        expect(response).to be_not_found
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new Strength", authorized: true do
          expect do
            post :create, params: { strength: valid_attributes }
          end.to change(Strength, :count).by(1)
        end

        it "renders a JSON response with the new strength", authorized: true do
          post :create, params: { strength: valid_attributes }
          expect(response).to have_http_status(:created)
          expect(response.content_type).to eq('application/json')
          expect(response.location).to eq(strength_url(Strength.last))
        end
      end

      context "with invalid params", authorized: true do
        it "renders a JSON response with errors for the new strength" do
          post :create, params: { strength: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end

        it "renders a 422 error for duplicate names", authorized: true do
          valid_strength = valid_attributes
          Strength.create! valid_strength

          post :create, params: { strength: valid_strength }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) do
          attributes_for(:strength)
        end

        it "updates the requested strength", authorized: true do
          strength = Strength.create! valid_attributes

          put :update, params: { id: strength.to_param, strength: new_attributes }
          strength.reload
          expect(strength.name).to eq(new_attributes[:name])
          expect(strength.description).to eq(new_attributes[:description])
        end

        it "renders a JSON response with the strength", authorized: true do
          strength = Strength.create! valid_attributes

          put :update, params: { id: strength.to_param, strength: valid_attributes }
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with deleted strength" do
        let(:new_attributes) do
          attributes_for(:strength)
        end

        it "does not updates the requested strength", authorized: true do
          strength = Strength.create! valid_attributes
          original_strength = strength
          strength.discard
          put :update, params: { id: strength.to_param, strength: new_attributes }
          strength.reload
          expect(strength.name).to eq(original_strength[:name])
          expect(strength.description).to eq(original_strength[:description])
        end

        it "renders a not found response", authorized: true do
          strength = Strength.create! valid_attributes
          strength.discard
          put :update, params: { id: strength.to_param, strength: valid_attributes }
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with invalid params" do
        it "renders a JSON response with errors for the strength", authorized: true do
          strength = Strength.create! valid_attributes

          put :update, params: { id: strength.to_param, strength: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end

        it "renders a 422 error for duplicate names", authorized: true do
          strength = Strength.create! valid_attributes
          another_strength = create(:strength)
          put :update, params: { id: strength.to_param, strength: attributes_for(:strength, name: another_strength.name) }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end

        it "does not updates the requested strength", authorized: true do
          strength = Strength.create! valid_attributes
          original_strength = strength

          put :update, params: { id: strength.to_param, strength: invalid_attributes }
          strength.reload
          expect(strength.name).to eq(original_strength[:name])
          expect(strength.description).to eq(original_strength[:description])
        end
      end
    end

    describe "DELETE #destroy" do
      it "soft deletes", authorized: true do
        strength = Strength.create! valid_attributes
        expect do
          delete :destroy, params: { id: strength.to_param }
        end.to change(Strength, :count).by(0)
      end

      it "sets discarded_at datetime", authorized: true do
        strength = Strength.create! valid_attributes
        delete :destroy, params: { id: strength.to_param }
        strength.reload
        expect(strength.discarded?).to be true
      end

      it "renders a JSON response with the strength", authorized: true do
        strength = Strength.create! valid_attributes

        delete :destroy, params: { id: strength.to_param }
        expect(response).to have_http_status(204)
      end

      it "renders a not found JSON response when the strength is deleted", authorized: true do
        strength = Strength.create! valid_attributes
        strength.discard
        delete :destroy, params: { id: strength.to_param }
        expect(response).to have_http_status(404)
      end

      it "returns a not found response when strength not found", authorized: true do
        delete :destroy, params: { id: 0 }
        expect(response).to be_not_found
      end
    end
  end

  describe "Unauthorised user" do
    describe "GET #index" do
      it "returns an unauthorized response", authorized: false do
        Strength.create! valid_attributes
        get :index

        expect_unauthorized
      end
    end

    describe "GET #show" do
      it "returns an unauthorized response", authorized: false do
        strength = Strength.create! valid_attributes
        get :show, params: { id: strength.to_param }

        expect_unauthorized
      end
    end

    describe "POST #create" do
      it "does not create a new Strength", authorized: false do
        expect do
          post :create, params: { strength: valid_attributes }
        end.to change(Strength, :count).by(0)
      end

      it "returns an unauthorized response", authorized: false do
        post :create, params: { strength: valid_attributes }
        expect_unauthorized
      end
    end

    describe "PUT #update" do
      let(:new_attributes) do
        attributes_for(:strength)
      end

      it "does not update the requested strength", authorized: false do
        strength = Strength.create! valid_attributes
        current_attributes = strength.attributes

        put :update, params: { id: strength.to_param, strength: new_attributes }
        strength.reload
        expect(strength.name).to eq(current_attributes["name"])
        expect(strength.description).to eq(current_attributes["description"])
      end

      it "returns an unauthorized response", authorized: false do
        strength = Strength.create! valid_attributes

        put :update, params: { id: strength.to_param, strength: valid_attributes }
        expect_unauthorized
      end
    end

    describe "DELETE #destroy" do
      it "does not destroy the requested strength", authorized: false do
        strength = Strength.create! valid_attributes
        expect do
          delete :destroy, params: { id: strength.to_param }
        end.to change(Strength, :count).by(0)
      end

      it "does not set discarded_at datetime", authorized: false do
        strength = Strength.create! valid_attributes
        delete :destroy, params: { id: strength.to_param }
        strength.reload
        expect(strength.discarded?).to be false
      end

      it "returns an unauthorized response", authorized: false do
        strength = Strength.create! valid_attributes

        delete :destroy, params: { id: strength.to_param }
        expect_unauthorized
      end
    end
  end
end