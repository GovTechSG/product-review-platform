require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe AspectsController, type: :controller do
  let(:valid_attributes) do
    build(:aspect).attributes
  end

  let(:invalid_attributes) do
    attributes_for(:aspect, name: nil, description: nil)
  end

  let(:token) { double acceptable?: true }

  before(:each, authorized: true) do
    allow(controller).to receive(:doorkeeper_token) { token }
  end

  describe "Authorised user" do
    describe "GET #index" do
      it "returns a success response", authorized: true do
        Aspect.create! valid_attributes
        get :index

        expect(response).to be_success
      end

      it "returns 25 result (1 page)", authorized: true do
        default_result_per_page = 25
        num_of_object_to_create = 30
        create_list(:aspect, num_of_object_to_create)

        get :index
        expect(JSON.parse(response.body).count).to match default_result_per_page
      end
    end

    describe "GET #show" do
      it "returns a success response", authorized: true do
        aspect = Aspect.create! valid_attributes
        get :show, params: { id: aspect.to_param }
        expect(response).to be_success
      end

      it "returns not found when aspect is deleted", authorized: true do
        aspect = Aspect.create! valid_attributes
        aspect.discard
        get :show, params: { id: aspect.to_param }
        expect(response.status).to eq(404)
      end

      it "returns not found when aspect not found", authorized: true do
        get :show, params: { id: 0 }
        expect(response).to be_not_found
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new Aspect", authorized: true do
          expect do
            post :create, params: { aspect: valid_attributes }
          end.to change(Aspect, :count).by(1)
        end

        it "renders a JSON response with the new aspect", authorized: true do
          post :create, params: { aspect: valid_attributes }
          expect(response).to have_http_status(:created)
          expect(response.content_type).to eq('application/json')
          expect(response.location).to eq(aspect_url(Aspect.last))
        end
      end

      context "with invalid params", authorized: true do
        it "renders a JSON response with errors for the new aspect" do
          post :create, params: { aspect: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end

        it "renders a 422 error for duplicate names", authorized: true do
          valid_aspect = valid_attributes
          Aspect.create! valid_aspect

          post :create, params: { aspect: valid_aspect }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) do
          attributes_for(:aspect)
        end

        it "updates the requested aspect", authorized: true do
          aspect = Aspect.create! valid_attributes

          put :update, params: { id: aspect.to_param, aspect: new_attributes }
          aspect.reload
          expect(aspect.name).to eq(new_attributes[:name])
          expect(aspect.description).to eq(new_attributes[:description])
        end

        it "renders a JSON response with the aspect", authorized: true do
          aspect = Aspect.create! valid_attributes

          put :update, params: { id: aspect.to_param, aspect: valid_attributes }
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with deleted aspect" do
        let(:new_attributes) do
          attributes_for(:aspect)
        end

        it "does not updates the requested aspect", authorized: true do
          aspect = Aspect.create! valid_attributes
          original_aspect = aspect
          aspect.discard
          put :update, params: { id: aspect.to_param, aspect: new_attributes }
          aspect.reload
          expect(aspect.name).to eq(original_aspect[:name])
          expect(aspect.description).to eq(original_aspect[:description])
        end

        it "renders a not found response", authorized: true do
          aspect = Aspect.create! valid_attributes
          aspect.discard
          put :update, params: { id: aspect.to_param, aspect: valid_attributes }
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with invalid params" do
        it "renders a JSON response with errors for the aspect", authorized: true do
          aspect = Aspect.create! valid_attributes

          put :update, params: { id: aspect.to_param, aspect: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end

        it "renders a 422 error for duplicate names", authorized: true do
          aspect = Aspect.create! valid_attributes
          another_aspect = create(:aspect)
          put :update, params: { id: aspect.to_param, aspect: attributes_for(:aspect, name: another_aspect.name) }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end

        it "does not updates the requested aspect", authorized: true do
          aspect = Aspect.create! valid_attributes
          original_aspect = aspect

          put :update, params: { id: aspect.to_param, aspect: invalid_attributes }
          aspect.reload
          expect(aspect.name).to eq(original_aspect[:name])
          expect(aspect.description).to eq(original_aspect[:description])
        end
      end
    end

    describe "DELETE #destroy" do
      it "soft deletes", authorized: true do
        aspect = Aspect.create! valid_attributes
        expect do
          delete :destroy, params: { id: aspect.to_param }
        end.to change(Aspect, :count).by(0)
      end

      it "sets discarded_at datetime", authorized: true do
        aspect = Aspect.create! valid_attributes
        delete :destroy, params: { id: aspect.to_param }
        aspect.reload
        expect(aspect.discarded?).to be true
      end

      it "renders a JSON response with the aspect", authorized: true do
        aspect = Aspect.create! valid_attributes

        delete :destroy, params: { id: aspect.to_param }
        expect(response).to have_http_status(204)
      end

      it "renders a not found JSON response when the aspect is deleted", authorized: true do
        aspect = Aspect.create! valid_attributes
        aspect.discard
        delete :destroy, params: { id: aspect.to_param }
        expect(response).to have_http_status(404)
      end

      it "returns a not found response when aspect not found", authorized: true do
        delete :destroy, params: { id: 0 }
        expect(response).to be_not_found
      end
    end
  end

  describe "Unauthorised user" do
    describe "GET #index" do
      it "returns an unauthorized response", authorized: false do
        Aspect.create! valid_attributes
        get :index

        expect_unauthorized
      end
    end

    describe "GET #show" do
      it "returns an unauthorized response", authorized: false do
        aspect = Aspect.create! valid_attributes
        get :show, params: { id: aspect.to_param }

        expect_unauthorized
      end
    end

    describe "POST #create" do
      it "does not create a new Aspect", authorized: false do
        expect do
          post :create, params: { aspect: valid_attributes }
        end.to change(Aspect, :count).by(0)
      end

      it "returns an unauthorized response", authorized: false do
        post :create, params: { aspect: valid_attributes }
        expect_unauthorized
      end
    end

    describe "PUT #update" do
      let(:new_attributes) do
        attributes_for(:aspect)
      end

      it "does not update the requested aspect", authorized: false do
        aspect = Aspect.create! valid_attributes
        current_attributes = aspect.attributes

        put :update, params: { id: aspect.to_param, aspect: new_attributes }
        aspect.reload
        expect(aspect.name).to eq(current_attributes["name"])
        expect(aspect.description).to eq(current_attributes["description"])
      end

      it "returns an unauthorized response", authorized: false do
        aspect = Aspect.create! valid_attributes

        put :update, params: { id: aspect.to_param, aspect: valid_attributes }
        expect_unauthorized
      end
    end

    describe "DELETE #destroy" do
      it "does not destroy the requested aspect", authorized: false do
        aspect = Aspect.create! valid_attributes
        expect do
          delete :destroy, params: { id: aspect.to_param }
        end.to change(Aspect, :count).by(0)
      end

      it "does not set discarded_at datetime", authorized: false do
        aspect = Aspect.create! valid_attributes
        delete :destroy, params: { id: aspect.to_param }
        aspect.reload
        expect(aspect.discarded?).to be false
      end

      it "returns an unauthorized response", authorized: false do
        aspect = Aspect.create! valid_attributes

        delete :destroy, params: { id: aspect.to_param }
        expect_unauthorized
      end
    end
  end
end