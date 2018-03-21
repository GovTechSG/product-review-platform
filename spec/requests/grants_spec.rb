require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe "Grants", type: :request do
  let(:valid_attributes) do
    build(:grant).attributes
  end

  let(:invalid_attributes) do
    build(:grant, name: nil, acronym: nil).attributes
  end

  describe "Authorised user" do
    describe "GET /api/v1/grants" do
      it "returns a success response" do
        Grant.create! valid_attributes
        get grants_path, headers: request_login

        expect(response).to be_success
      end
    end

    describe "GET /api/v1/companies/:company_id/grants" do
      it "returns a success response" do
        review = create(:product_review)
        get company_grants_path(review.reviewable.company_id), headers: request_login

        expect(response).to be_success
      end

      it "does not return grants from deleted company" do
        review = create(:product_review)
        review.reviewable.company.discard
        get company_grants_path(review.reviewable.company_id), headers: request_login
        expect(response.status).to eq(404)
      end

      it "returns not found if the company is not found" do
        get company_grants_path(0), headers: request_login
        expect(response.status).to eq(404)
      end
    end

    describe "GET /api/v1/grants/:id" do
      it "returns a success response" do
        grant = Grant.create! valid_attributes
        get grant_path(grant.id), headers: request_login
        expect(response).to be_success
      end

      it "returns not found when grant is deleted" do
        grant = Grant.create! valid_attributes
        grant.discard
        get grant_path(grant.id), headers: request_login
        expect(response.status).to eq(404)
      end

      it "returns not found when grant not found" do
        get grant_path(0), headers: request_login
        expect(response).to be_not_found
      end
    end

    describe "POST /api/v1/grants" do
      context "with valid params" do
        it "creates a new Grant" do
          expect do
            post grants_path, params: { grant: valid_attributes }, headers: request_login
          end.to change(Grant, :count).by(1)
        end

        it "renders a JSON response with the new grant" do
          post grants_path, params: { grant: valid_attributes }, headers: request_login
          expect(response).to have_http_status(:created)
          expect(response.content_type).to eq('application/json')
          expect(response.location).to eq(grant_url(Grant.last))
        end

        it "renders 404 when agency is not found" do
          grant_with_no_agency = valid_attributes
          grant_with_no_agency["agency_id"] = 0
          post grants_path, params: { grant: grant_with_no_agency }, headers: request_login
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end

        it "renders 404 when agency is deleted" do
          grant_with_no_agency = valid_attributes
          Agency.find_by(id: grant_with_no_agency["agency_id"]).discard
          post grants_path, params: { grant: grant_with_no_agency }, headers: request_login
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with invalid params" do
        it "renders a JSON response with errors for the new grant" do
          post grants_path, params: { grant: invalid_attributes }, headers: request_login
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end

        it "renders a 422 error for duplicate names" do
          valid_grant = valid_attributes
          Grant.create! valid_grant

          post grants_path, params: { grant: valid_grant }, headers: request_login
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    describe "PUT /api/v1/grants/:id" do
      context "with valid params" do
        let(:new_attributes) do
          build(:grant).attributes.with_indifferent_access
        end

        it "updates the requested grant" do
          grant = Grant.create! valid_attributes

          put grant_path(grant.id), params: { grant: new_attributes }, headers: request_login
          grant.reload
          expect(grant.name).to eq(new_attributes[:name])
          expect(grant.description).to eq(new_attributes[:description])
          expect(grant.acronym).to eq(new_attributes[:acronym])
          expect(grant.agency_id).to eq(new_attributes[:agency_id])
        end

        it "renders a JSON response with the grant" do
          grant = Grant.create! valid_attributes

          put grant_path(grant.id), params: { grant: new_attributes }, headers: request_login
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('application/json')
        end

        it "has an optional agency id field" do
          grant = Grant.create! valid_attributes
          old_grant = grant
          new_attributes_no_agency = new_attributes.except(:agency_id)
          put grant_path(grant.id), params: { grant: new_attributes_no_agency }, headers: request_login
          grant.reload

          expect(grant.name).to eq(new_attributes[:name])
          expect(grant.description).to eq(new_attributes[:description])
          expect(grant.acronym).to eq(new_attributes[:acronym])
          expect(grant.agency_id).to eq(old_grant[:agency_id])
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('application/json')
        end

        it "renders 404 when agency is not found" do
          grant = Grant.create! valid_attributes
          old_grant = grant
          new_attributes["agency_id"] = 0
          put grant_path(grant.id), params: { grant: new_attributes }, headers: request_login
          grant.reload

          expect(grant.name).to eq(old_grant[:name])
          expect(grant.description).to eq(old_grant[:description])
          expect(grant.acronym).to eq(old_grant[:acronym])
          expect(grant.agency_id).to eq(old_grant[:agency_id])
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end

        it "renders 404 when agency is deleted" do
          grant = Grant.create! valid_attributes
          old_grant = grant
          agency = create(:agency)
          agency.discard
          new_attributes["agency_id"] = agency.id
          put grant_path(grant.id), params: { grant: new_attributes }, headers: request_login
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

        it "does not updates the requested grant" do
          grant = Grant.create! valid_attributes
          original_grant = grant
          grant.discard
          put grant_path(grant.id), params: { grant: new_attributes }, headers: request_login
          grant.reload
          expect(grant.name).to eq(original_grant[:name])
          expect(grant.description).to eq(original_grant[:description])
          expect(grant.acronym).to eq(original_grant[:acronym])
        end

        it "renders a not found response" do
          grant = Grant.create! valid_attributes
          grant.discard
          put grant_path(grant.id), params: { grant: new_attributes }, headers: request_login
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with invalid params" do
        it "renders a JSON response with errors for the grant" do
          grant = Grant.create! valid_attributes

          put grant_path(grant.id), params: { grant: invalid_attributes }, headers: request_login
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end

        it "renders a 422 error for duplicate names" do
          grant = Grant.create! valid_attributes
          another_grant = create(:grant)
          put grant_path(grant.id), params: { grant: another_grant.attributes }, headers: request_login
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end

        it "does not update the requested grant" do
          grant = Grant.create! valid_attributes
          original_grant = grant

          put grant_path(grant.id), params: { grant: invalid_attributes }, headers: request_login
          grant.reload
          expect(grant.name).to eq(original_grant[:name])
          expect(grant.description).to eq(original_grant[:description])
          expect(grant.acronym).to eq(original_grant[:acronym])
        end
      end
    end

    describe "DELETE /api/v1/grants/:id" do
      it "soft deletes" do
        grant = Grant.create! valid_attributes
        expect do
          delete grant_path(grant.id), headers: request_login
        end.to change(Grant, :count).by(0)
      end

      it "sets discarded_at datetime" do
        grant = Grant.create! valid_attributes
        delete grant_path(grant.id), headers: request_login
        grant.reload
        expect(grant.discarded?).to be true
      end

      it "renders a JSON response with the grant" do
        grant = Grant.create! valid_attributes

        delete grant_path(grant.id), headers: request_login
        expect(response).to have_http_status(204)
      end

      it "renders a not found JSON response when the grant is deleted" do
        grant = Grant.create! valid_attributes
        grant.discard
        delete grant_path(grant.id), headers: request_login
        expect(response).to have_http_status(404)
      end

      it "returns a not found response when grant not found" do
        delete grant_path(0), headers: request_login
        expect(response).to be_not_found
      end
    end
  end

  describe "Unauthorised user" do
    describe "GET /api/v1/grants" do
      it "returns an unauthorized response" do
        Grant.create! valid_attributes
        get grants_path

        expect_unauthorized
      end
    end

    describe "GET /api/v1/companies/:company_id/grants" do
      it "returns an unauthorized response" do
        review = create(:product_review)
        get company_grants_path(review.reviewable.company_id)

        expect_unauthorized
      end
    end

    describe "GET /api/v1/grants/:id" do
      it "returns an unauthorized response" do
        grant = Grant.create! valid_attributes
        get grant_path(grant.id)

        expect_unauthorized
      end
    end

    describe "POST /api/v1/grants" do
      it "does not create a new Grant" do
        expect do
          post grants_path, params: { grant: valid_attributes }
        end.to change(Grant, :count).by(0)
      end

      it "returns an unauthorized response" do
        post grants_path, params: { grant: valid_attributes }
        expect_unauthorized
      end
    end

    describe "PUT /api/v1/grants/:id" do
      let(:new_attributes) do
        attributes_for(:grant)
      end

      it "does not update the requested grant" do
        grant = Grant.create! valid_attributes
        current_attributes = grant.attributes

        put grant_path(grant.id), params: { grant: new_attributes }
        grant.reload
        expect(grant.name).to eq(current_attributes["name"])
        expect(grant.description).to eq(current_attributes["description"])
        expect(grant.acronym).to eq(current_attributes["acronym"])
      end

      it "returns an unauthorized response" do
        grant = Grant.create! valid_attributes

        put grant_path(grant.id), params: { grant: new_attributes }
        expect_unauthorized
      end
    end

    describe "DELETE /api/v1/grants/:id" do
      it "does not destroy the requested grant" do
        grant = Grant.create! valid_attributes
        expect do
          delete grant_path(grant.id)
        end.to change(Grant, :count).by(0)
      end

      it "does not set discarded_at datetime" do
        grant = Grant.create! valid_attributes
        delete grant_path(grant.id)
        grant.reload
        expect(grant.discarded?).to be false
      end

      it "returns an unauthorized response" do
        grant = Grant.create! valid_attributes

        delete grant_path(grant.id)
        expect_unauthorized
      end
    end
  end
end
