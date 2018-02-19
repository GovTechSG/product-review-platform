require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe "Users", type: :request do
  let(:valid_attributes) do
    build(:user).attributes
  end

  let(:invalid_attributes) do
    build(:user, name: nil, email: nil, number: nil).attributes
  end

  describe "Authorised user" do
    describe "GET /api/v1/users" do
      it "returns a success response" do
        User.create! valid_attributes
        get users_path, headers: request_login

        expect(response).to be_success
      end
    end

    describe "GET /api/v1/users/:id" do
      it "returns a success response" do
        user = User.create! valid_attributes
        get user_path(user.to_param), headers: request_login
        expect(response).to be_success
      end

      it "returns not found when user not found" do
        get user_path(0), headers: request_login
        expect(response).to be_not_found
      end
    end

    describe "POST api/v1/users" do
      context "with valid params" do
        it "creates a new User" do
          expect do
            post users_path, params: { user: valid_attributes }, headers: request_login
          end.to change(User, :count).by(1)
        end

        it "renders a JSON response with the new user" do
          post users_path, params: { user: valid_attributes }, headers: request_login
          expect(response).to have_http_status(:created)
          expect(response.content_type).to eq('application/json')
          expect(response.location).to eq(user_url(User.last))
        end
      end

      context "with invalid params" do
        it "renders a JSON response with errors for the new user" do
          post users_path, params: { user: invalid_attributes }, headers: request_login
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    describe "PUT api/v1/users/id" do
      context "with valid params" do
        let(:new_attributes) do
          attributes_for(:user)
        end

        it "updates the requested user" do
          user = User.create! valid_attributes

          put user_path(user.id), params: { user: new_attributes }, headers: request_login
          user.reload
          expect(user.name).to eq(new_attributes[:name])
          expect(user.email).to eq(new_attributes[:email])
          expect(user.number).to eq(new_attributes[:number])
        end

        it "renders a JSON response with the user" do
          user = User.create! valid_attributes

          put user_path(user.id), params: { user: new_attributes }, headers: request_login
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with invalid id" do
        it "renders a JSON response with errors for the user" do
          put user_path(0), params: { user: attributes_for(:user) }, headers: request_login
          expect(response).to be_not_found
        end
      end

      context "with invalid params" do
        it "renders a JSON response with errors for the user" do
          user = User.create! valid_attributes

          put user_path(user.id), params: { user: invalid_attributes }, headers: request_login
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    describe "DELETE #destroy" do
      it "soft deletes" do
        user = User.create! valid_attributes
        expect do
          delete user_path(user.id), headers: request_login
        end.to change(User, :count).by(0)
      end

      it "sets discarded_at datetime" do
        user = User.create! valid_attributes
        delete user_path(user.id), headers: request_login
        user.reload
        expect(user.discarded?).to be true
      end

      it "renders a JSON response with the user" do
        user = User.create! valid_attributes

        delete user_path(user.id), headers: request_login
        expect(response).to have_http_status(204)
      end

      it "returns a not found response when user not found" do
        delete user_path(0), headers: request_login
        expect(response).to be_not_found
      end
    end
  end

  describe "Unauthorised user" do
    describe "GET #index" do
      it "returns an unauthorized response" do
        User.create! valid_attributes
        get users_path, headers: nil

        expect_unauthorized
      end
    end

    describe "GET #show" do
      it "returns an unauthorized response" do
        user = User.create! valid_attributes
        get user_path(user.id), headers: nil

        expect_unauthorized
      end
    end

    describe "POST #create" do
      it "does not create a new User" do
        expect do
          post users_path, params: { user: valid_attributes }, headers: nil
        end.to change(User, :count).by(0)
      end

      it "returns an unauthorized response" do
        post users_path, params: { user: valid_attributes }, headers: nil
        expect_unauthorized
      end
    end

    describe "PUT #update" do
      let(:new_attributes) do
        attributes_for(:user)
      end

      it "does not update the requested user" do
        user = User.create! valid_attributes
        current_attributes = user.attributes

        put user_path(user.id), params: { user: new_attributes }, headers: nil
        user.reload
        expect(user.name).to eq(current_attributes["name"])
        expect(user.number).to eq(current_attributes["number"])
        expect(user.email).to eq(current_attributes["email"])
      end

      it "returns an unauthorized response" do
        user = User.create! valid_attributes

        put user_path(user.id), params: { user: valid_attributes }, headers: nil
        expect_unauthorized
      end
    end

    describe "DELETE #destroy" do
      it "does not destroy the requested user" do
        user = User.create! valid_attributes
        expect do
          delete user_path(user.id), headers: nil
        end.to change(User, :count).by(0)
      end

      it "does not set discarded_at datetime" do
        user = User.create! valid_attributes
        delete user_path(user.id), headers: nil
        user.reload
        expect(user.discarded?).to be false
      end

      it "returns an unauthorized response" do
        user = User.create! valid_attributes

        delete user_path(user.id), headers: nil
        expect_unauthorized
      end
    end
  end
end
