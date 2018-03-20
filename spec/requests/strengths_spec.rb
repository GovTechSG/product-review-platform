require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe "Strengths", type: :request do
  let(:valid_attributes) do
    build(:strength).attributes
  end

  let(:invalid_attributes) do
    attributes_for(:strength, name: nil, acronym: nil, agency_id: nil)
  end

  describe "Authorised user" do
    describe "GET /api/v1/strengths" do
      it "returns a success response" do
        Strength.create! valid_attributes
        get strengths_path, headers: request_login

        expect(response).to be_success
      end
    end

    describe "GET /api/v1/strengths/:id" do
      it "returns a success response" do
        strength = Strength.create! valid_attributes
        get strength_path(strength.id), headers: request_login
        expect(response).to be_success
      end

      it "returns not found when strength is deleted" do
        strength = Strength.create! valid_attributes
        strength.discard
        get strength_path(strength.id), headers: request_login
        expect(response.status).to eq(404)
      end

      it "returns not found when strength not found" do
        get strength_path(0), headers: request_login
        expect(response).to be_not_found
      end
    end

    describe "POST /api/v1/strengths" do
      context "with valid params" do
        it "creates a new Strength" do
          expect do
            post strengths_path, params: { strength: valid_attributes }, headers: request_login
          end.to change(Strength, :count).by(1)
        end

        it "renders a JSON response with the new strength" do
          post strengths_path, params: { strength: valid_attributes }, headers: request_login
          expect(response).to have_http_status(:created)
          expect(response.content_type).to eq('application/json')
          expect(response.location).to eq(strength_url(Strength.last))
        end
      end

      context "with invalid params" do
        it "renders a JSON response with errors for the new strength" do
          post strengths_path, params: { strength: invalid_attributes }, headers: request_login
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end

        it "renders a 422 error for duplicate names" do
          valid_strength = valid_attributes
          Strength.create! valid_strength

          post strengths_path, params: { strength: valid_strength }, headers: request_login
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    describe "PUT /api/v1/strengths/:id" do
      context "with valid params" do
        let(:new_attributes) do
          attributes_for(:strength)
        end

        it "updates the requested strength" do
          strength = Strength.create! valid_attributes

          put strength_path(strength.id), params: { strength: new_attributes }, headers: request_login
          strength.reload
          expect(strength.name).to eq(new_attributes[:name])
          expect(strength.description).to eq(new_attributes[:description])
        end

        it "renders a JSON response with the strength" do
          strength = Strength.create! valid_attributes

          put strength_path(strength.id), params: { strength: new_attributes }, headers: request_login
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with deleted strength" do
        let(:new_attributes) do
          attributes_for(:strength)
        end

        it "does not updates the requested strength" do
          strength = Strength.create! valid_attributes
          original_strength = strength
          strength.discard
          put strength_path(strength.id), params: { strength: new_attributes }, headers: request_login
          strength.reload
          expect(strength.name).to eq(original_strength[:name])
          expect(strength.description).to eq(original_strength[:description])
        end

        it "renders a not found response" do
          strength = Strength.create! valid_attributes
          strength.discard
          put strength_path(strength.id), params: { strength: new_attributes }, headers: request_login
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with invalid params" do
        it "renders a JSON response with errors for the strength" do
          strength = Strength.create! valid_attributes

          put strength_path(strength.id), params: { strength: invalid_attributes }, headers: request_login
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end

        it "renders a 422 error for duplicate names" do
          strength = Strength.create! valid_attributes
          another_strength = create(:strength)
          put strength_path(strength.id), params: { strength: another_strength.attributes }, headers: request_login
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end

        it "does not update the requested strength" do
          strength = Strength.create! valid_attributes
          original_strength = strength

          put strength_path(strength.id), params: { strength: invalid_attributes }, headers: request_login
          strength.reload
          expect(strength.name).to eq(original_strength[:name])
          expect(strength.description).to eq(original_strength[:description])
        end
      end
    end

    describe "DELETE /api/v1/strengths/:id" do
      it "soft deletes" do
        strength = Strength.create! valid_attributes
        expect do
          delete strength_path(strength.id), headers: request_login
        end.to change(Strength, :count).by(0)
      end

      it "sets discarded_at datetime" do
        strength = Strength.create! valid_attributes
        delete strength_path(strength.id), headers: request_login
        strength.reload
        expect(strength.discarded?).to be true
      end

      it "renders a JSON response with the strength" do
        strength = Strength.create! valid_attributes

        delete strength_path(strength.id), headers: request_login
        expect(response).to have_http_status(204)
      end

      it "renders a not found JSON response when the strength is deleted" do
        strength = Strength.create! valid_attributes
        strength.discard
        delete strength_path(strength.id), headers: request_login
        expect(response).to have_http_status(404)
      end

      it "returns a not found response when strength not found" do
        delete strength_path(0), headers: request_login
        expect(response).to be_not_found
      end
    end
  end

  describe "Unauthorised user" do
    describe "GET /api/v1/strengths" do
      it "returns an unauthorized response" do
        Strength.create! valid_attributes
        get strengths_path

        expect_unauthorized
      end
    end

    describe "GET /api/v1/strengths/:id" do
      it "returns an unauthorized response" do
        strength = Strength.create! valid_attributes
        get strength_path(strength.id)

        expect_unauthorized
      end
    end

    describe "POST /api/v1/strengths" do
      it "does not create a new Strength" do
        expect do
          post strengths_path, params: { strength: valid_attributes }
        end.to change(Strength, :count).by(0)
      end

      it "returns an unauthorized response" do
        post strengths_path, params: { strength: valid_attributes }
        expect_unauthorized
      end
    end

    describe "PUT /api/v1/strengths/:id" do
      let(:new_attributes) do
        attributes_for(:strength)
      end

      it "does not update the requested strength" do
        strength = Strength.create! valid_attributes
        current_attributes = strength.attributes

        put strength_path(strength.id), params: { strength: new_attributes }
        strength.reload
        expect(strength.name).to eq(current_attributes["name"])
        expect(strength.description).to eq(current_attributes["description"])
      end

      it "returns an unauthorized response" do
        strength = Strength.create! valid_attributes

        put strength_path(strength.id), params: { strength: new_attributes }
        expect_unauthorized
      end
    end

    describe "DELETE /api/v1/strengths/:id" do
      it "does not destroy the requested strength" do
        strength = Strength.create! valid_attributes
        expect do
          delete strength_path(strength.id)
        end.to change(Strength, :count).by(0)
      end

      it "does not set discarded_at datetime" do
        strength = Strength.create! valid_attributes
        delete strength_path(strength.id)
        strength.reload
        expect(strength.discarded?).to be false
      end

      it "returns an unauthorized response" do
        strength = Strength.create! valid_attributes

        delete strength_path(strength.id)
        expect_unauthorized
      end
    end
  end
end
