require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe "Services", type: :request do
  let(:valid_attributes) do
    build(:service).attributes
  end

  let(:invalid_attributes) do
    build(:service, name: nil).attributes
  end

  describe "Authorised user" do
    describe "GET /api/v1/companies/:company_id/services" do
      it "returns a success response" do
        service = Service.create! valid_attributes
        get company_services_path(service.company.id), headers: request_login

        expect(response).to be_success
      end

      it "returns not found if the company is deleted" do
        service = Service.create! valid_attributes
        service.company.discard
        get company_services_path(service.company.id), headers: request_login

        expect(response).to be_not_found
      end

      it "returns not found if the company is not found" do
        get company_services_path(0), headers: request_login

        expect(response).to be_not_found
      end

      it "does not return deleted services" do
        service = Service.create! valid_attributes
        service.discard
        get company_services_path(service.company.id), headers: request_login

        expect(response).to be_success
        expect(parsed_response).to match([])
      end
    end

    describe "GET /services/:id" do
      it "returns a success response" do
        service = Service.create! valid_attributes
        get service_path(service.id), headers: request_login
        expect(response).to be_success
      end

      it "returns not found when the service is deleted" do
        service = Service.create! valid_attributes
        service.discard
        get service_path(service.id), headers: request_login
        expect(response).to be_not_found
      end

      it "returns not found when the company is deleted" do
        service = Service.create! valid_attributes
        service.company.discard
        get service_path(service.id), headers: request_login
        expect(response).to be_not_found
      end

      it "returns not found when service not found" do
        get service_path(0), headers: request_login
        expect(response).to be_not_found
      end
    end

    describe "POST /api/v1/companies/:company_id/services" do
      context "with valid params" do
        it "creates a new Service" do
          company = create(:company)

          expect do
            post company_services_path(company.id), params: { service: valid_attributes }, headers: request_login
          end.to change(Service, :count).by(1)
        end

        it "renders a JSON response with the new service" do
          company = create(:company)

          post company_services_path(company.id), params: { service: valid_attributes }, headers: request_login
          expect(response).to have_http_status(:created)
          expect(response.content_type).to eq('application/json')
          expect(response.location).to eq(service_url(Service.last))
        end

        it "renders not found if the company is not found" do
          post company_services_path(0), params: { service: valid_attributes }, headers: request_login
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end

        it "renders not found if the company is deleted" do
          company = create(:company)
          company.discard

          post company_services_path(company.id), params: { service: valid_attributes }, headers: request_login
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with invalid params" do
        it "renders a JSON response with errors for the new service" do
          company = create(:company)

          post company_services_path(company.id), params: { service: invalid_attributes }, headers: request_login
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    describe "PUT /api/v1/services/:id" do
      context "with valid params" do
        let(:new_attributes) do
          attributes_for(:service)
        end

        it "updates the requested service" do
          service = Service.create! valid_attributes

          put service_path(service), params: { service: new_attributes }, headers: request_login
          service.reload
          expect(service.name).to eq(new_attributes[:name])
          expect(service.description).to eq(new_attributes[:description])
        end

        it "renders a JSON response with the service" do
          service = Service.create! valid_attributes

          put service_path(service), params: { service: new_attributes }, headers: request_login
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('application/json')
        end

        it "does not update the requested service when the company is deleted" do
          service = Service.create! valid_attributes
          original_service = service
          service.company.discard
          put service_path(service), params: { service: new_attributes }, headers: request_login
          service.reload
          expect(service.name).to eq(original_service[:name])
          expect(service.description).to eq(original_service[:description])
        end

        it "does not update the requested service when the service is deleted" do
          service = Service.create! valid_attributes
          original_service = service
          service.discard
          put service_path(service), params: { service: new_attributes }, headers: request_login
          service.reload
          expect(service.name).to eq(original_service[:name])
          expect(service.description).to eq(original_service[:description])
        end

        it "renders not found when the service is not found" do
          put service_path(0), params: { service: new_attributes }, headers: request_login
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end

        it "renders a JSON response with the service" do
          service = Service.create! valid_attributes

          put service_path(service), params: { service: new_attributes }, headers: request_login
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with invalid params" do
        it "renders a JSON response with errors for the service" do
          service = Service.create! valid_attributes

          put service_path(service), params: { service: invalid_attributes }, headers: request_login
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    describe "DELETE /api/v1/services/:id" do
      it "soft deletes" do
        service = Service.create! valid_attributes
        expect do
          delete service_path(service.id), params: {}, headers: request_login
        end.to change(Service, :count).by(0)
      end

      it "sets discarded_at datetime" do
        service = Service.create! valid_attributes
        delete service_path(service.id), params: {}, headers: request_login
        service.reload
        expect(service.discarded?).to be true
      end

      it "renders a JSON response with the service" do
        service = Service.create! valid_attributes

        delete service_path(service.id), params: {}, headers: request_login
        expect(response).to have_http_status(204)
      end

      it "render not found when the service is deleted" do
        service = Service.create! valid_attributes
        service.discard
        delete service_path(service.id), params: {}, headers: request_login
        expect(response).to have_http_status(404)
      end

      it "render not found when the company is deleted" do
        service = Service.create! valid_attributes
        service.company.discard
        delete service_path(service.id), params: {}, headers: request_login
        expect(response).to have_http_status(404)
      end

      it "returns a not found response when service not found" do
        delete service_path(0), params: {}, headers: request_login
        expect(response).to be_not_found
      end
    end
  end

  describe "Unauthorised user" do
    describe "GET /api/v1/companies/:company_id/services" do
      it "returns an unauthorized response" do
        service = Service.create! valid_attributes
        get company_services_path(service.company.id), headers: nil

        expect_unauthorized
      end
    end

    describe "GET /services/:id" do
      it "returns an unauthorized response" do
        service = Service.create! valid_attributes
        get service_path(service.id), headers: nil

        expect_unauthorized
      end
    end

    describe "POST /api/v1/companies/:company_id/services" do
      it "does not create a new Service" do
        company = create(:company)

        expect do
          post company_services_path(company.id), params: { service: valid_attributes }, headers: nil
        end.to change(Service, :count).by(0)
      end

      it "returns an unauthorized response" do
        company = create(:company)

        post company_services_path(company.id), params: { service: valid_attributes }, headers: nil
        expect_unauthorized
      end
    end

    describe "PUT /services/:id" do
      let(:new_attributes) do
        attributes_for(:service)
      end

      it "does not update the requested service" do
        service = Service.create! valid_attributes
        current_attributes = service.attributes

        put service_path(service), params: { service: new_attributes }, headers: nil
        service.reload
        expect(service.name).to eq(current_attributes["name"])
        expect(service.description).to eq(current_attributes["description"])
      end

      it "returns an unauthorized response" do
        service = Service.create! valid_attributes

        put service_path(service), params: { service: new_attributes }, headers: nil
        expect_unauthorized
      end
    end

    describe "DELETE /api/v1/services/:id" do
      it "does not destroy the requested service" do
        service = Service.create! valid_attributes
        expect do
          delete service_path(service.id), params: {}, headers: nil
        end.to change(Service, :count).by(0)
      end

      it "does not set discarded_at datetime" do
        service = Service.create! valid_attributes
        delete service_path(service.id), params: {}, headers: nil
        service.reload
        expect(service.discarded?).to be false
      end

      it "returns an unauthorized response" do
        service = Service.create! valid_attributes

        delete service_path(service.id), params: {}, headers: nil
        expect_unauthorized
      end
    end
  end
end
