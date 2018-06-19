require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe GrantsController, type: :controller do
  let(:valid_attributes) do
    build(:grant).attributes
  end

  let(:valid_params_attributes) do
    value = build(:grant).attributes
    value["agency_id"] = Agency.find(value["agency_id"]).hashid
    value
  end

  let(:invalid_attributes) do
    build(:grant, name: nil, acronym: nil).attributes
  end

  let(:invalid_params_attributes) do
    value = build(:grant, name: nil, acronym: nil).attributes
    value["agency_id"] = Agency.find(value["agency_id"]).hashid
    value
  end

  let(:token) { double acceptable?: true }

  before(:each, authorized: true) do
    allow(controller).to receive(:doorkeeper_token) { token }
  end

  describe "Authorised user" do
    describe "GET #index grant" do
      it "returns a success response", authorized: true do
        Grant.create! valid_attributes
        get :index

        expect(response).to be_success
      end

      it "returns 25 result (1 page)", authorized: true do
        default_result_per_page = 25
        num_of_object_to_create = 30
        create_list(:grant, num_of_object_to_create)

        get :index
        expect(JSON.parse(response.body).count).to match default_result_per_page
      end
    end

    describe "GET #index company" do
      it "returns a success response", authorized: true do
        review = create(:product_review)
        get :index, params: { company_id: review.reviewable.company.hashid }

        expect(response).to be_success
      end

      it "does not return grants from deleted company", authorized: true do
        review = create(:product_review)
        review.reviewable.company.discard
        get :index, params: { company_id: review.reviewable.company.hashid }
        expect(response.status).to eq(404)
      end

      it "returns not found if the company is not found", authorized: true do
        get :index, params: { company_id: 0 }
        expect(response.status).to eq(404)
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
            post :create, params: { grant: valid_params_attributes }
          end.to change(Grant, :count).by(1)
        end

        it "renders a JSON response with the new grant", authorized: true do
          post :create, params: { grant: valid_params_attributes }
          expect(response).to have_http_status(:created)
          expect(response.content_type).to eq('application/json')
          expect(response.location).to eq(grant_url(Grant.last))
        end
      end

      context "with invalid params", authorized: true do
        it "renders a JSON response with errors for the new grant" do
          post :create, params: { grant: invalid_params_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end

        it "renders a 422 error for duplicate names", authorized: true do
          valid_grant = valid_attributes
          Grant.create! valid_grant

          post :create, params: { grant: invalid_params_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end

        it "renders 404 when agency is not found", authorized: true do
          grant_with_no_agency = valid_attributes
          grant_with_no_agency["agency_id"] = 0
          post :create, params: { grant: grant_with_no_agency }
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end

        it "renders 404 when agency is deleted", authorized: true do
          grant_with_no_agency = valid_attributes
          Agency.find_by(id: grant_with_no_agency["agency_id"]).discard
          post :create, params: { grant: grant_with_no_agency }
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) do
          value = build(:grant).attributes.with_indifferent_access
          value["agency_id"] = Agency.find(value["agency_id"]).hashid
          value
        end

        it "updates the requested grant", authorized: true do
          grant = Grant.create! valid_attributes

          put :update, params: { id: grant.to_param, grant: new_attributes }

          grant.reload
          expect(grant.name).to eq(new_attributes[:name])
          expect(grant.description).to eq(new_attributes[:description])
          expect(grant.acronym).to eq(new_attributes[:acronym])
          expect(grant.agency.hashid).to eq(new_attributes[:agency_id])
        end

        it "renders a JSON response with the grant", authorized: true do
          grant = Grant.create! valid_attributes

          put :update, params: { id: grant.to_param, grant: new_attributes }
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('application/json')
        end

        it "has an optional agency id field", authorized: true do
          grant = Grant.create! valid_attributes
          old_grant = grant
          new_attributes_no_agency = new_attributes.except(:agency_id)
          put :update, params: { id: grant.to_param, grant: new_attributes_no_agency }
          grant.reload

          expect(grant.name).to eq(new_attributes[:name])
          expect(grant.description).to eq(new_attributes[:description])
          expect(grant.acronym).to eq(new_attributes[:acronym])
          expect(grant.agency_id).to eq(old_grant[:agency_id])
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('application/json')
        end

        it "renders 404 when agency is not found", authorized: true do
          grant = Grant.create! valid_attributes
          old_grant = grant
          new_attributes["agency_id"] = 0
          put :update, params: { id: grant.to_param, grant: new_attributes }
          grant.reload

          expect(grant.name).to eq(old_grant[:name])
          expect(grant.description).to eq(old_grant[:description])
          expect(grant.acronym).to eq(old_grant[:acronym])
          expect(grant.agency_id).to eq(old_grant[:agency_id])
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end

        it "renders 404 when agency is deleted", authorized: true do
          grant = Grant.create! valid_attributes
          old_grant = grant
          agency = create(:agency)
          agency.discard
          new_attributes["agency_id"] = agency.id
          put :update, params: { id: grant.to_param, grant: new_attributes }
          grant.reload

          expect(grant.name).to eq(old_grant[:name])
          expect(grant.description).to eq(old_grant[:description])
          expect(grant.acronym).to eq(old_grant[:acronym])
          expect(grant.agency_id).to eq(old_grant[:agency_id])
          expect(response).to have_http_status(404)
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

          put :update, params: { id: grant.to_param, grant: invalid_params_attributes }

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

    describe "GET #index company" do
      it "returns a nunauthorized response", authorized: false do
        review = create(:product_review)
        get :index, params: { company_id: review.reviewable.company_id }

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