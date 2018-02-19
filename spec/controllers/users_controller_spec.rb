require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe UsersController, type: :controller do
  let(:valid_attributes) do
    build(:user).attributes
  end

  let(:invalid_attributes) do
    build(:user, name: nil, email: nil, number: nil).attributes
  end

  let(:valid_session) {}

  let(:token) { double acceptable?: true }

  before(:each, authorized: true) do
    allow(controller).to receive(:doorkeeper_token) { token }
  end

  describe "Authorised user" do
    describe "GET #index" do
      it "returns a success response", authorized: true do
        User.create! valid_attributes
        get :index

        expect(response).to be_success
      end
    end

    describe "GET #show" do
      it "returns a success response", authorized: true do
        user = User.create! valid_attributes
        get :show, params: { id: user.to_param }
        expect(response).to be_success
      end

      it "returns not found when user not found", authorized: true do
        get :show, params: { id: 0 }
        expect(response).to be_not_found
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new User", authorized: true do
          expect do
            post :create, params: { user: valid_attributes }
          end.to change(User, :count).by(1)
        end

        it "renders a JSON response with the new user", authorized: true do
          post :create, params: { user: valid_attributes }
          expect(response).to have_http_status(:created)
          expect(response.content_type).to eq('application/json')
          expect(response.location).to eq(user_url(User.last))
        end
      end

      context "with invalid params", authorized: true do
        it "renders a JSON response with errors for the new user" do
          post :create, params: { user: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) do
          attributes_for(:user)
        end

        it "updates the requested user", authorized: true do
          user = User.create! valid_attributes

          put :update, params: { id: user.to_param, user: new_attributes }, session: valid_session
          user.reload
          expect(user.name).to eq(new_attributes[:name])
          expect(user.email).to eq(new_attributes[:email])
          expect(user.number).to eq(new_attributes[:number])
        end

        it "renders a JSON response with the user", authorized: true do
          user = User.create! valid_attributes

          put :update, params: { id: user.to_param, user: valid_attributes }, session: valid_session
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with invalid id" do
        it "renders a JSON response with errors for the user", authorized: true do
          put :update, params: { id: 0, user: valid_attributes }, session: valid_session
          expect(response).to be_not_found
        end
      end

      context "with invalid params" do
        it "renders a JSON response with errors for the user", authorized: true do
          user = User.create! valid_attributes

          put :update, params: { id: user.to_param, user: invalid_attributes }, session: valid_session
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    describe "DELETE #destroy" do
      it "soft deletes", authorized: true do
        user = User.create! valid_attributes
        expect do
          delete :destroy, params: { id: user.to_param }, session: valid_session
        end.to change(User, :count).by(0)
      end

      it "sets discarded_at datetime", authorized: true do
        user = User.create! valid_attributes
        delete :destroy, params: { id: user.to_param }
        user.reload
        expect(user.discarded?).to be true
      end

      it "renders a JSON response with the user", authorized: true do
        user = User.create! valid_attributes

        delete :destroy, params: { id: user.to_param }
        expect(response).to have_http_status(204)
      end

      it "returns a not found response when user not found", authorized: true do
        delete :destroy, params: { id: 0 }
        expect(response).to be_not_found
      end
    end
  end

  describe "Unauthorised user" do
    describe "GET #index" do
      it "returns an unauthorized response", authorized: false do
        User.create! valid_attributes
        get :index

        expect_unauthorized
      end
    end

    describe "GET #show" do
      it "returns an unauthorized response", authorized: false do
        user = User.create! valid_attributes
        get :show, params: { id: user.to_param }

        expect_unauthorized
      end
    end

    describe "POST #create" do
      it "does not create a new User", authorized: false do
        expect do
          post :create, params: { user: valid_attributes }
        end.to change(User, :count).by(0)
      end

      it "returns an unauthorized response", authorized: false do
        post :create, params: { user: valid_attributes }
        expect_unauthorized
      end
    end

    describe "PUT #update" do
      let(:new_attributes) do
        attributes_for(:user)
      end

      it "does not update the requested user", authorized: false do
        user = User.create! valid_attributes
        current_attributes = user.attributes

        put :update, params: { id: user.to_param, user: new_attributes }, session: valid_session
        user.reload
        expect(user.name).to eq(current_attributes["name"])
        expect(user.number).to eq(current_attributes["number"])
        expect(user.email).to eq(current_attributes["email"])
      end

      it "returns an unauthorized response", authorized: false do
        user = User.create! valid_attributes

        put :update, params: { id: user.to_param, user: valid_attributes }, session: valid_session
        expect_unauthorized
      end
    end

    describe "DELETE #destroy" do
      it "does not destroy the requested user", authorized: false do
        user = User.create! valid_attributes
        expect do
          delete :destroy, params: { id: user.to_param }, session: valid_session
        end.to change(User, :count).by(0)
      end

      it "does not set discarded_at datetime", authorized: false do
        user = User.create! valid_attributes
        delete :destroy, params: { id: user.to_param }
        user.reload
        expect(user.discarded?).to be false
      end

      it "returns an unauthorized response", authorized: false do
        user = User.create! valid_attributes

        delete :destroy, params: { id: user.to_param }, session: valid_session
        expect_unauthorized
      end
    end
  end
end
