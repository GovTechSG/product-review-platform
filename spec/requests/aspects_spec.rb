require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe "Aspects", type: :request do
  let(:valid_attributes) do
    build(:aspect).attributes
  end

  let(:invalid_attributes) do
    attributes_for(:aspect, name: nil, acronym: nil, agency_id: nil)
  end

  describe "Authorised user" do
    describe "GET /api/v1/aspects" do
      it "returns a success response" do
        Aspect.create! valid_attributes
        get aspects_path, headers: request_login

        expect(response).to be_success
      end
    end

    describe "GET /api/v1/aspects/:id" do
      it "returns a success response" do
        aspect = Aspect.create! valid_attributes
        get aspect_path(aspect.id), headers: request_login
        expect(response).to be_success
      end

      it "returns not found when aspect is deleted" do
        aspect = Aspect.create! valid_attributes
        aspect.discard
        get aspect_path(aspect.id), headers: request_login
        expect(response.status).to eq(404)
      end

      it "returns not found when aspect not found" do
        get aspect_path(0), headers: request_login
        expect(response).to be_not_found
      end
    end

    describe "POST /api/v1/aspects" do
      context "with valid params" do
        it "creates a new Aspect" do
          expect do
            post aspects_path, params: { aspect: valid_attributes }, headers: request_login
          end.to change(Aspect, :count).by(1)
        end

        it "renders a JSON response with the new aspect" do
          post aspects_path, params: { aspect: valid_attributes }, headers: request_login
          expect(response).to have_http_status(:created)
          expect(response.content_type).to eq('application/json')
          expect(response.location).to eq(aspect_url(Aspect.last))
        end
      end

      context "with invalid params" do
        it "renders a JSON response with errors for the new aspect" do
          post aspects_path, params: { aspect: invalid_attributes }, headers: request_login
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end

        it "renders a 422 error for duplicate names" do
          valid_aspect = valid_attributes
          Aspect.create! valid_aspect

          post aspects_path, params: { aspect: valid_aspect }, headers: request_login
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    describe "PUT /api/v1/aspects/:id" do
      context "with valid params" do
        let(:new_attributes) do
          attributes_for(:aspect)
        end

        it "updates the requested aspect" do
          aspect = Aspect.create! valid_attributes

          put aspect_path(aspect.id), params: { aspect: new_attributes }, headers: request_login
          aspect.reload
          expect(aspect.name).to eq(new_attributes[:name])
          expect(aspect.description).to eq(new_attributes[:description])
        end

        it "renders a JSON response with the aspect" do
          aspect = Aspect.create! valid_attributes

          put aspect_path(aspect.id), params: { aspect: new_attributes }, headers: request_login
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with deleted aspect" do
        let(:new_attributes) do
          attributes_for(:aspect)
        end

        it "does not updates the requested aspect" do
          aspect = Aspect.create! valid_attributes
          original_aspect = aspect
          aspect.discard
          put aspect_path(aspect.id), params: { aspect: new_attributes }, headers: request_login
          aspect.reload
          expect(aspect.name).to eq(original_aspect[:name])
          expect(aspect.description).to eq(original_aspect[:description])
        end

        it "renders a not found response" do
          aspect = Aspect.create! valid_attributes
          aspect.discard
          put aspect_path(aspect.id), params: { aspect: new_attributes }, headers: request_login
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with invalid params" do
        it "renders a JSON response with errors for the aspect" do
          aspect = Aspect.create! valid_attributes

          put aspect_path(aspect.id), params: { aspect: invalid_attributes }, headers: request_login
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end

        it "renders a 422 error for duplicate names" do
          aspect = Aspect.create! valid_attributes
          another_aspect = create(:aspect)
          put aspect_path(aspect.id), params: { aspect: another_aspect.attributes }, headers: request_login
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end

        it "does not update the requested aspect" do
          aspect = Aspect.create! valid_attributes
          original_aspect = aspect

          put aspect_path(aspect.id), params: { aspect: invalid_attributes }, headers: request_login
          aspect.reload
          expect(aspect.name).to eq(original_aspect[:name])
          expect(aspect.description).to eq(original_aspect[:description])
        end
      end
    end

    describe "DELETE /api/v1/aspects/:id" do
      it "soft deletes" do
        aspect = Aspect.create! valid_attributes
        expect do
          delete aspect_path(aspect.id), headers: request_login
        end.to change(Aspect, :count).by(0)
      end

      it "sets discarded_at datetime" do
        aspect = Aspect.create! valid_attributes
        delete aspect_path(aspect.id), headers: request_login
        aspect.reload
        expect(aspect.discarded?).to be true
      end

      it "renders a JSON response with the aspect" do
        aspect = Aspect.create! valid_attributes

        delete aspect_path(aspect.id), headers: request_login
        expect(response).to have_http_status(204)
      end

      it "renders a not found JSON response when the aspect is deleted" do
        aspect = Aspect.create! valid_attributes
        aspect.discard
        delete aspect_path(aspect.id), headers: request_login
        expect(response).to have_http_status(404)
      end

      it "returns a not found response when aspect not found" do
        delete aspect_path(0), headers: request_login
        expect(response).to be_not_found
      end
    end
  end

  describe "Unauthorised user" do
    describe "GET /api/v1/aspects" do
      it "returns an unauthorized response" do
        Aspect.create! valid_attributes
        get aspects_path

        expect_unauthorized
      end
    end

    describe "GET /api/v1/aspects/:id" do
      it "returns an unauthorized response" do
        aspect = Aspect.create! valid_attributes
        get aspect_path(aspect.id)

        expect_unauthorized
      end
    end

    describe "POST /api/v1/aspects" do
      it "does not create a new Aspect" do
        expect do
          post aspects_path, params: { aspect: valid_attributes }
        end.to change(Aspect, :count).by(0)
      end

      it "returns an unauthorized response" do
        post aspects_path, params: { aspect: valid_attributes }
        expect_unauthorized
      end
    end

    describe "PUT /api/v1/aspects/:id" do
      let(:new_attributes) do
        attributes_for(:aspect)
      end

      it "does not update the requested aspect" do
        aspect = Aspect.create! valid_attributes
        current_attributes = aspect.attributes

        put aspect_path(aspect.id), params: { aspect: new_attributes }
        aspect.reload
        expect(aspect.name).to eq(current_attributes["name"])
        expect(aspect.description).to eq(current_attributes["description"])
      end

      it "returns an unauthorized response" do
        aspect = Aspect.create! valid_attributes

        put aspect_path(aspect.id), params: { aspect: new_attributes }
        expect_unauthorized
      end
    end

    describe "DELETE /api/v1/aspects/:id" do
      it "does not destroy the requested aspect" do
        aspect = Aspect.create! valid_attributes
        expect do
          delete aspect_path(aspect.id)
        end.to change(Aspect, :count).by(0)
      end

      it "does not set discarded_at datetime" do
        aspect = Aspect.create! valid_attributes
        delete aspect_path(aspect.id)
        aspect.reload
        expect(aspect.discarded?).to be false
      end

      it "returns an unauthorized response" do
        aspect = Aspect.create! valid_attributes

        delete aspect_path(aspect.id)
        expect_unauthorized
      end
    end
  end
end
