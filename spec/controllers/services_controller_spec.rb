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

  before(:each) do
    @service = create(:service)
    @service.companies.create!(build(:company_as_params))
  end

  describe "Authorised user" do
    describe "GET #index" do
      it "returns a success response", authorized: true do
        get :index, params: { company_id: @service.companies.first.hashid }

        expect(response).to be_success
      end

      it "returns 25 result (1 page)", authorized: true do
        default_result_per_page = 25
        num_of_object_to_create = 30
        company = Company.create! build(:company).attributes

        while num_of_object_to_create > 0
          service = create(:service)
          CompanyReviewable.create!(company: company, reviewable: service)

          num_of_object_to_create -= 1
        end

        get :index, params: { company_id: company.hashid }
        expect(JSON.parse(response.body).count).to match default_result_per_page
      end

      it "does not return deleted services", authorized: true do
        @service.discard
        get :index, params: { company_id: @service.companies.first.hashid }
        expect(parsed_response).to match([])
        expect(response).to be_success
      end

      it "returns not found when the service's company is deleted", authorized: true do
        @service.companies.first.discard
        get :index, params: { company_id: @service.companies.first.hashid }

        expect(response).to be_not_found
      end

      it "returns not found when service's company ID not found", authorized: true do
        get :index, params: { company_id: 0 }
        expect(response).to be_not_found
      end
    end

    describe "GET #show" do
      it "returns a success response", authorized: true do
        get :show, params: { id: @service.to_param }
        expect(response).to be_success
      end

      it "returns a not found when the service is deleted", authorized: true do
        @service.discard
        get :show, params: { id: @service.to_param }
        expect(response).to be_not_found
      end

      it "returns a not found when all company is discarded", authorized: true do
        @service.companies.first.discard
        get :show, params: { id: @service.to_param }
        expect(response).to be_not_found
      end

      it "returns success when at least one company is not discarded", authorized: true do
        @service.companies.create!(build(:company_as_params))
        @service.companies.first.discard
        get :show, params: { id: @service.to_param }
        expect(response).to be_success
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
          put :update, params: { id: @service.to_param, service: new_attributes }, session: valid_session
          @service.reload
          expect(@service.name).to eq(new_attributes[:name])
          expect(@service.description).to eq(new_attributes[:description])
        end

        it "renders a JSON response with the service", authorized: true do
          put :update, params: { id: @service.to_param, service: valid_attributes }, session: valid_session
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('application/json')
        end

        it "returns not found when service ID not found", authorized: true do
          put :update, params: { id: 0, service: valid_attributes }, session: valid_session
          expect(response).to be_not_found
        end

        it "renders not found when service is deleted", authorized: true do
          @service.discard
          put :update, params: { id: @service.to_param, service: valid_attributes }, session: valid_session
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end

        it "does not update when service is deleted", authorized: true do
          original_attributes = @service
          @service.discard
          put :update, params: { id: @service.to_param, service: valid_attributes }, session: valid_session
          @service.reload
          expect(@service.name).to eq(original_attributes[:name])
          expect(@service.description).to eq(original_attributes[:description])
        end

        it "renders not found when company is deleted", authorized: true do
          @service.companies.first.discard
          put :update, params: { id: @service.to_param, service: valid_attributes }, session: valid_session
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end

        it "does not update when company is deleted", authorized: true do
          original_attributes = @service
          @service.companies.first.discard
          put :update, params: { id: @service.to_param, service: valid_attributes }, session: valid_session
          @service.reload
          expect(@service.name).to eq(original_attributes[:name])
          expect(@service.description).to eq(original_attributes[:description])
        end
      end

      context "with invalid params" do
        it "renders a JSON response with errors for the service", authorized: true do
          put :update, params: { id: @service.to_param, service: invalid_attributes }, session: valid_session
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    describe "DELETE #destroy" do
      it "soft deletes", authorized: true do
        expect do
          delete :destroy, params: { id: @service.to_param }, session: valid_session
        end.to change(Service, :count).by(0)
      end

      it "sets discarded_at datetime", authorized: true do
        delete :destroy, params: { id: @service.to_param }
        @service.reload
        expect(@service.discarded?).to be true
      end

      it "renders a JSON response with the service", authorized: true do
        delete :destroy, params: { id: @service.to_param }
        expect(response).to have_http_status(204)
      end

      it "renders a not found if the service is deleted", authorized: true do
        @service.discard
        delete :destroy, params: { id: @service.to_param }
        expect(response).to have_http_status(404)
      end

      it "renders a not found if the company is deleted", authorized: true do
        @service.companies.first.discard
        delete :destroy, params: { id: @service.to_param }
        expect(response).to have_http_status(404)
      end

      it "returns a not found response when service not found", authorized: true do
        delete :destroy, params: { id: 0 }
        expect(response).to be_not_found
      end
    end

    describe "POST #search", authorized: true do
      it "returns a success response when service is found" do
        post :search, params: { service_name: @service.name, company: { uen: 999, name: 'test', description: 'for test' }, vendor_name: @service.companies.first.name, vendor_uen: @service.companies.first.uen }
        expect(response).to be_success
      end

      it "creates service if service is not found" do
        expect do
          post :search, params: { service_name: "new service", service: { description: '' }, company: { uen: 999, name: 'test', description: 'for test' }, vendor_name: "new vendor", vendor_uen: 123 }
        end.to change { Service.count }.by(1)
      end

      it "does not create service if service is found" do
        post :search, params: { service_name: "new service", service: { description: '' }, company: { uen: 999, name: 'test', description: 'for test' }, vendor_name: "new vendor", vendor_uen: 123 }
        expect do
          post :search, params: { service_name: "new service", service: { description: '' }, company: { uen: 999, name: 'test', description: 'for test' }, vendor_name: "new vendor", vendor_uen: 123 }
        end.to change { Service.count }.by(0)
      end

      it "creates vendor if vendor is not found" do
        company = create(:company)
        expect do
          post :search, params: { service_name: "new service", service: { description: '' }, company: { uen: company.uen, name: company.name, description: company.description }, vendor_name: "new vendor", vendor_uen: 123 }
        end.to change { Company.count }.by(1)
      end

      it "does not create vendor or reviewer if vendor is found" do
        company = create(:company)
        service = create(:service)
        CompanyReviewable.create(company: company, reviewable: service)
        expect do
          post :search, params: { service_name: service.name, service: { description: service.description }, company: { uen: company.uen, name: company.name, description: company.description }, vendor_name: service.companies.first.name, vendor_uen: service.companies.first.uen }
        end.to change { Company.count }.by(0)
      end

      it "creates reviewer if reviewer is not found" do
        company = create(:company)
        service = create(:service)
        CompanyReviewable.create(company: company, reviewable: service)
        expect do
          post :search, params: { service_name: service.name, service: { description: service.description }, company: { uen: 123, name: "aname", description: "adesc" }, vendor_name: service.companies.first.name, vendor_uen: service.companies.first.uen }
        end.to change { Company.count }.by(1)
      end

      it "seaches by uen" do
        service = create(:service)
        reviewer = create(:company)
        CompanyReviewable.create(company: reviewer, reviewable: service)
        post :search, params: { service_name: service.name, service: { description: service.description }, company: { uen: reviewer.uen, name: "aname", description: "adesc" }, vendor_name: "wrong", vendor_uen: service.companies.first.uen }
        expect(response).to be_success
      end

      it "searches by name if uen is not found" do
        service = create(:service)
        reviewer = create(:company)
        CompanyReviewable.create(company: reviewer, reviewable: service)
        post :search, params: { service_name: service.name, service: { description: service.description }, company: { uen: 123, name: reviewer.name, description: "adesc" }, vendor_name: service.companies.first.name, vendor_uen: 321 }
        expect(response).to be_success
      end

      it "searches by name if uen is blank" do
        service = create(:service)
        reviewer = create(:company)
        CompanyReviewable.create(company: reviewer, reviewable: service)
        post :search, params: { service_name: service.name, service: { description: service.description }, company: { uen: "", name: reviewer.name, description: "adesc" }, vendor_name: service.companies.first.name, vendor_uen: "" }
        expect(response).to be_success
      end

      it "can submit multiple blanks" do
        service = build(:service)

        expect do
          expect do
            post :search, params: { service_name: service.name, service: { description: service.description }, company: { uen: "", name: "aname", description: "adesc" }, vendor_name: "bname", vendor_uen: "" }
            post :search, params: { service_name: service.name, service: { description: service.description }, company: { uen: "", name: "abname", description: "adesc" }, vendor_name: "vname", vendor_uen: "" }
          end.to change { Company.count }.by(4)
        end.to change { Service.count }.by(1)
      end

      it "returns a success response" do
        post :search, params: { service_name: 'test', service: { description: 'for test' }, company: { uen: 999, name: 'test', description: 'for test' }, vendor_name: "abc", vendor_uen: 123 }
        expect(response).to be_success
      end

      it "requires vendor name and uen" do
        post :search, params: { service_name: 'test', service: { description: 'for test' }, company: { uen: 999, name: 'test', description: 'for test' } }
        expect(response.status).to eq(404)
      end

      it "returns a unprocessable_entity response when company creation failed" do
        post :search, params: { service_name: 'test', company: { uen: 999, name: '', description: '' }, vendor_name: "abc", vendor_uen: 123 }
        expect(response.status).to eq(422)
      end

      it "returns a company when company uen is found" do
        create(:company, uen: "999")
        post :search, params: { service_name: 'test', service: { description: 'test' }, company: { uen: 999, name: '', description: '' }, vendor_name: "abc", vendor_uen: 123 }
        expect(response).to be_success
      end

      it "returns a company when company uen is not found but name is found" do
        create(:company, name: "tEst name", uen: "999")
        post :search, params: { service_name: 'test', service: { description: 'test' }, company: { uen: 888, name: '  Test NaMe   ', description: '' }, vendor_name: "abc", vendor_uen: 123 }
        expect(response).to be_success
      end
    end
  end

  describe "Unauthorised user" do
    describe "GET #index" do
      it "returns an unauthorized response", authorized: false do
        get :index, params: { company_id: @service.companies.first.hashid }

        expect_unauthorized
      end
    end

    describe "GET #show" do
      it "returns an unauthorized response", authorized: false do
        get :show, params: { id: @service.to_param }

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
        current_attributes = @service.attributes

        put :update, params: { id: @service.to_param, service: new_attributes }, session: valid_session
        @service.reload
        expect(@service.name).to eq(current_attributes["name"])
        expect(@service.description).to eq(current_attributes["description"])
      end

      it "returns an unauthorized response", authorized: false do
        put :update, params: { id: @service.to_param, service: valid_attributes }, session: valid_session
        expect_unauthorized
      end
    end

    describe "DELETE #destroy" do
      it "does not destroy the requested service", authorized: false do
        expect do
          delete :destroy, params: { id: @service.to_param }, session: valid_session
        end.to change(Service, :count).by(0)
      end

      it "does not set discarded_at datetime", authorized: false do
        delete :destroy, params: { id: @service.to_param }
        @service.reload
        expect(@service.discarded?).to be false
      end
      it "returns an unauthorized response", authorized: false do
        delete :destroy, params: { id: @service.to_param }, session: valid_session
        expect_unauthorized
      end
    end
  end
end
