require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe ServicesController, type: :controller do
  let(:valid_attributes) do
    build(:service).attributes
  end

  let(:invalid_attributes) do
    build(:service, name: nil).attributes
  end

  let(:valid_session) {}

  let(:token) { double acceptable?: true }

  before(:each, authorized: true) do
    allow(controller).to receive(:doorkeeper_token) { token }
  end

  describe "Authorised user" do
    describe "GET #index" do
      it "returns a success response", authorized: true do
        service = Service.create! valid_attributes
        get :index, params: { company_id: service.company.hashid }

        expect(response).to be_success
      end

      it "returns 25 result (1 page)", authorized: true do
        default_result_per_page = 25
        num_of_object_to_create = 30
        company = Company.create! build(:company).attributes

        while num_of_object_to_create > 0
          Service.create! build(:service, company: company).attributes
          num_of_object_to_create -= 1
        end

        get :index, params: { company_id: company.hashid }
        expect(JSON.parse(response.body).count).to match default_result_per_page
      end

      it "does not return deleted services", authorized: true do
        service = Service.create! valid_attributes
        service.discard
        get :index, params: { company_id: service.company.hashid }
        expect(parsed_response).to match([])
        expect(response).to be_success
      end

      it "returns not found when the service's company is deleted", authorized: true do
        service = Service.create! valid_attributes
        service.company.discard
        get :index, params: { company_id: service.company.id }

        expect(response).to be_not_found
      end

      it "returns not found when service's company ID not found", authorized: true do
        get :index, params: { company_id: 0 }
        expect(response).to be_not_found
      end
    end

    describe "GET #show" do
      it "returns a success response", authorized: true do
        service = Service.create! valid_attributes
        get :show, params: { id: service.to_param }
        expect(response).to be_success
      end

      it "returns a not found when the service is deleted", authorized: true do
        service = Service.create! valid_attributes
        service.discard
        get :show, params: { id: service.to_param }
        expect(response).to be_not_found
      end

      it "returns a not found when the company is deleted", authorized: true do
        service = Service.create! valid_attributes
        service.company.discard
        get :show, params: { id: service.to_param }
        expect(response).to be_not_found
      end

      it "returns not found when service not found", authorized: true do
        get :show, params: { id: 0 }
        expect(response).to be_not_found
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new Service", authorized: true do
          company = create(:company)

          expect do
            post :create, params: { service: valid_attributes, company_id: company.hashid }
          end.to change(Service, :count).by(1)
        end

        it "renders a JSON response with the new service", authorized: true do
          company = create(:company)

          post :create, params: { service: valid_attributes, company_id: company.hashid }
          expect(response).to have_http_status(:created)
          expect(response.content_type).to eq('application/json')
          expect(response.location).to eq(service_url(Service.last))
        end

        it "returns not found when service's company ID not found", authorized: true do
          post :create, params: { service: valid_attributes, company_id: 0 }
          expect(response).to be_not_found
        end

        it "renders not found when the service's company is deleted", authorized: true do
          company = create(:company)
          company.discard
          post :create, params: { service: valid_attributes, company_id: company.id }
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end
        it "does not create when the service's company is deleted", authorized: true do
          company = create(:company)
          company.discard
          expect do
            post :create, params: { service: valid_attributes, company_id: company.id }
          end.to change(Service, :count).by(0)
        end
      end

      context "with invalid params", authorized: true do
        it "renders a JSON response with errors for the new service" do
          company = create(:company)

          post :create, params: { service: invalid_attributes, company_id: company.hashid }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) do
          attributes_for(:service)
        end

        it "updates the requested service", authorized: true do
          service = Service.create! valid_attributes

          put :update, params: { id: service.to_param, service: new_attributes }, session: valid_session
          service.reload
          expect(service.name).to eq(new_attributes[:name])
          expect(service.description).to eq(new_attributes[:description])
        end

        it "renders a JSON response with the service", authorized: true do
          service = Service.create! valid_attributes

          put :update, params: { id: service.to_param, service: valid_attributes }, session: valid_session
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('application/json')
        end

        it "returns not found when service ID not found", authorized: true do
          put :update, params: { id: 0, service: valid_attributes }, session: valid_session
          expect(response).to be_not_found
        end

        it "renders not found when service is deleted", authorized: true do
          service = Service.create! valid_attributes
          service.discard
          put :update, params: { id: service.to_param, service: valid_attributes }, session: valid_session
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end

        it "does not update when service is deleted", authorized: true do
          service = Service.create! valid_attributes
          original_attributes = service
          service.discard
          put :update, params: { id: service.to_param, service: valid_attributes }, session: valid_session
          service.reload
          expect(service.name).to eq(original_attributes[:name])
          expect(service.description).to eq(original_attributes[:description])
        end

        it "renders not found when company is deleted", authorized: true do
          service = Service.create! valid_attributes
          service.company.discard
          put :update, params: { id: service.to_param, service: valid_attributes }, session: valid_session
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end

        it "does not update when company is deleted", authorized: true do
          service = Service.create! valid_attributes
          original_attributes = service
          service.company.discard
          put :update, params: { id: service.to_param, service: valid_attributes }, session: valid_session
          service.reload
          expect(service.name).to eq(original_attributes[:name])
          expect(service.description).to eq(original_attributes[:description])
        end
      end

      context "with invalid params" do
        it "renders a JSON response with errors for the service", authorized: true do
          service = Service.create! valid_attributes

          put :update, params: { id: service.to_param, service: invalid_attributes }, session: valid_session
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    describe "DELETE #destroy" do
      it "soft deletes", authorized: true do
        service = Service.create! valid_attributes
        expect do
          delete :destroy, params: { id: service.to_param }, session: valid_session
        end.to change(Service, :count).by(0)
      end

      it "sets discarded_at datetime", authorized: true do
        service = Service.create! valid_attributes
        delete :destroy, params: { id: service.to_param }
        service.reload
        expect(service.discarded?).to be true
      end

      it "renders a JSON response with the service", authorized: true do
        service = Service.create! valid_attributes

        delete :destroy, params: { id: service.to_param }
        expect(response).to have_http_status(204)
      end

      it "renders a not found if the service is deleted", authorized: true do
        service = Service.create! valid_attributes
        service.discard
        delete :destroy, params: { id: service.to_param }
        expect(response).to have_http_status(404)
      end

      it "renders a not found if the company is deleted", authorized: true do
        service = Service.create! valid_attributes
        service.company.discard
        delete :destroy, params: { id: service.to_param }
        expect(response).to have_http_status(404)
      end

      it "returns a not found response when service not found", authorized: true do
        delete :destroy, params: { id: 0 }
        expect(response).to be_not_found
      end
    end
  end

  describe "Unauthorised user" do
    describe "GET #index" do
      it "returns an unauthorized response", authorized: false do
        service = Service.create! valid_attributes
        get :index, params: { company_id: service.company.id }

        expect_unauthorized
      end
    end

    describe "GET #show" do
      it "returns an unauthorized response", authorized: false do
        service = Service.create! valid_attributes
        get :show, params: { id: service.to_param }

        expect_unauthorized
      end
    end

    describe "POST #create" do
      it "does not create a new Service", authorized: false do
        company = create(:company)

        expect do
          post :create, params: { service: valid_attributes, company_id: company.id }
        end.to change(Service, :count).by(0)
      end

      it "returns an unauthorized response", authorized: false do
        company = create(:company)

        post :create, params: { service: valid_attributes, company_id: company.id }
        expect_unauthorized
      end
    end

    describe "PUT #update" do
      let(:new_attributes) do
        attributes_for(:service)
      end

      it "does not update the requested service", authorized: false do
        service = Service.create! valid_attributes
        current_attributes = service.attributes

        put :update, params: { id: service.to_param, service: new_attributes }, session: valid_session
        service.reload
        expect(service.name).to eq(current_attributes["name"])
        expect(service.description).to eq(current_attributes["description"])
      end

      it "returns an unauthorized response", authorized: false do
        service = Service.create! valid_attributes

        put :update, params: { id: service.to_param, service: valid_attributes }, session: valid_session
        expect_unauthorized
      end
    end

    describe "DELETE #destroy" do
      it "does not destroy the requested service", authorized: false do
        service = Service.create! valid_attributes
        expect do
          delete :destroy, params: { id: service.to_param }, session: valid_session
        end.to change(Service, :count).by(0)
      end

      it "does not set discarded_at datetime", authorized: false do
        service = Service.create! valid_attributes
        delete :destroy, params: { id: service.to_param }
        service.reload
        expect(service.discarded?).to be false
      end
      it "returns an unauthorized response", authorized: false do
        service = Service.create! valid_attributes
        delete :destroy, params: { id: service.to_param }, session: valid_session
        expect_unauthorized
      end
    end
  end
end
