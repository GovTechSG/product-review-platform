require 'rails_helper'
require 'support/api_login_helper'

RSpec.describe ProjectsController, type: :controller do
  let(:valid_attributes) do
    build(:project).attributes
  end

  let(:invalid_attributes) do
    build(:project, name: nil).attributes
  end

  let(:valid_session) {}

  let(:token) { double acceptable?: true }

  before(:each, authorized: true) do
    allow(controller).to receive(:doorkeeper_token) { token }
  end

  before(:each) do
    @project = create(:project)
    @project.companies.create!(build(:company_as_params))
  end

  describe "Authorised user" do
    describe "GET #index" do
      it "returns a success response", authorized: true do
        get :index, params: { company_id: @project.companies.first.hashid }

        expect(response).to be_success
      end

      it "returns 25 result (1 page)", authorized: true do
        default_result_per_page = 25
        num_of_object_to_create = 30
        company = Company.create! build(:company).attributes

        while num_of_object_to_create > 0
          project = create(:project)
          CompanyReviewable.create!(company: company, reviewable: project)

          num_of_object_to_create -= 1
        end

        get :index, params: { company_id: company.hashid }
        expect(JSON.parse(response.body).count).to match default_result_per_page
      end

      it "does not return deleted projects", authorized: true do
        @project.discard
        get :index, params: { company_id: @project.companies.first.hashid }
        expect(parsed_response).to match([])
        expect(response).to be_success
      end

      it "returns not found when the project's company is deleted", authorized: true do
        @project.companies.first.discard
        get :index, params: { company_id: @project.companies.first.hashid }

        expect(response).to be_not_found
      end

      it "returns not found when project's company ID not found", authorized: true do
        get :index, params: { company_id: 0 }
        expect(response).to be_not_found
      end
    end

    describe "GET #show" do
      it "returns a success response", authorized: true do
        get :show, params: { id: @project.to_param }
        expect(response).to be_success
      end

      it "returns a not found when the project is deleted", authorized: true do
        @project.discard
        get :show, params: { id: @project.to_param }
        expect(response).to be_not_found
      end

      it "returns a not found when all company is discarded", authorized: true do
        @project.companies.first.discard
        get :show, params: { id: @project.to_param }
        expect(response).to be_not_found
      end

      it "returns success when at least one company is not discarded", authorized: true do
        @project.companies.create!(build(:company_as_params))
        @project.companies.first.discard
        get :show, params: { id: @project.to_param }
        expect(response).to be_success
      end

      it "returns not found when project not found", authorized: true do
        get :show, params: { id: 0 }
        expect(response).to be_not_found
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new Project", authorized: true do
          company = create(:company)

          expect do
            post :create, params: { project: valid_attributes, company_id: company.hashid }
          end.to change(Project, :count).by(1)
        end

        it "renders a JSON response with the new project", authorized: true do
          company = create(:company)

          post :create, params: { project: valid_attributes, company_id: company.hashid }
          expect(response).to have_http_status(:created)
          expect(response.content_type).to eq('application/json')
          expect(response.location).to eq(project_url(Project.last))
        end

        it "returns not found when project's company ID not found", authorized: true do
          post :create, params: { project: valid_attributes, company_id: 0 }
          expect(response).to be_not_found
        end

        it "renders not found when the project's company is deleted", authorized: true do
          company = create(:company)
          company.discard
          post :create, params: { project: valid_attributes, company_id: company.id }
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end
        it "does not create when the project's company is deleted", authorized: true do
          company = create(:company)
          company.discard
          expect do
            post :create, params: { project: valid_attributes, company_id: company.id }
          end.to change(Project, :count).by(0)
        end
      end

      context "with invalid params", authorized: true do
        it "renders a JSON response with errors for the new project" do
          company = create(:company)

          post :create, params: { project: invalid_attributes, company_id: company.hashid }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) do
          attributes_for(:project)
        end

        it "updates the requested project", authorized: true do
          put :update, params: { id: @project.to_param, project: new_attributes }, session: valid_session
          @project.reload
          expect(@project.name).to eq(new_attributes[:name])
          expect(@project.description).to eq(new_attributes[:description])
        end

        it "renders a JSON response with the project", authorized: true do
          put :update, params: { id: @project.to_param, project: valid_attributes }, session: valid_session
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('application/json')
        end

        it "returns not found when project ID not found", authorized: true do
          put :update, params: { id: 0, project: valid_attributes }, session: valid_session
          expect(response).to be_not_found
        end

        it "renders not found when project is deleted", authorized: true do
          @project.discard
          put :update, params: { id: @project.to_param, project: valid_attributes }, session: valid_session
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end

        it "does not update when project is deleted", authorized: true do
          original_attributes = @project
          @project.discard
          put :update, params: { id: @project.to_param, project: valid_attributes }, session: valid_session
          @project.reload
          expect(@project.name).to eq(original_attributes[:name])
          expect(@project.description).to eq(original_attributes[:description])
        end

        it "renders not found when company is deleted", authorized: true do
          @project.companies.first.discard
          put :update, params: { id: @project.to_param, project: valid_attributes }, session: valid_session
          expect(response).to have_http_status(404)
          expect(response.content_type).to eq('application/json')
        end

        it "does not update when company is deleted", authorized: true do
          original_attributes = @project
          @project.companies.first.discard
          put :update, params: { id: @project.to_param, project: valid_attributes }, session: valid_session
          @project.reload
          expect(@project.name).to eq(original_attributes[:name])
          expect(@project.description).to eq(original_attributes[:description])
        end
      end

      context "with invalid params" do
        it "renders a JSON response with errors for the project", authorized: true do
          put :update, params: { id: @project.to_param, project: invalid_attributes }, session: valid_session
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    describe "DELETE #destroy" do
      it "soft deletes", authorized: true do
        expect do
          delete :destroy, params: { id: @project.to_param }, session: valid_session
        end.to change(Project, :count).by(0)
      end

      it "sets discarded_at datetime", authorized: true do
        delete :destroy, params: { id: @project.to_param }
        @project.reload
        expect(@project.discarded?).to be true
      end

      it "renders a JSON response with the project", authorized: true do
        delete :destroy, params: { id: @project.to_param }
        expect(response).to have_http_status(204)
      end

      it "renders a not found if the project is deleted", authorized: true do
        @project.discard
        delete :destroy, params: { id: @project.to_param }
        expect(response).to have_http_status(404)
      end

      it "renders a not found if the company is deleted", authorized: true do
        @project.companies.first.discard
        delete :destroy, params: { id: @project.to_param }
        expect(response).to have_http_status(404)
      end

      it "returns a not found response when project not found", authorized: true do
        delete :destroy, params: { id: 0 }
        expect(response).to be_not_found
      end
    end

    describe "POST #search", authorized: true do
      it "allows multiple companies to be part of the project", authorized: true do
        expect do
          post :search, params: { project_name: "new project", project: { description: '' }, company: { uen: 999, name: 'test', description: 'for test' }, vendor_name: "new vendor", vendor_uen: 123 }
          post :search, params: { project_name: "new project", project: { description: '' }, company: { uen: 999, name: 'test', description: 'for test' }, vendor_name: "new vendor2", vendor_uen: 1234 }
        end.to change { CompanyReviewable.count }.by(2)
      end
      it "returns a success response when project is found" do
        post :search, params: { project_name: @project.name, company: { uen: 999, name: 'test', description: 'for test' }, vendor_name: @project.companies.first.name, vendor_uen: @project.companies.first.uen }
        expect(response).to be_success
      end

      it "creates project if project is not found" do
        expect do
          post :search, params: { project_name: "new project", project: { description: '' }, company: { uen: 999, name: 'test', description: 'for test' }, vendor_name: "new vendor", vendor_uen: 123 }
        end.to change { Project.count }.by(1)
      end

      it "does not create project if project is found" do
        post :search, params: { project_name: "new project", project: { description: '' }, company: { uen: 999, name: 'test', description: 'for test' }, vendor_name: "new vendor", vendor_uen: 123 }
        expect do
          post :search, params: { project_name: "new project", project: { description: '' }, company: { uen: 999, name: 'test', description: 'for test' }, vendor_name: "new vendor", vendor_uen: 123 }
        end.to change { Project.count }.by(0)
      end

      it "creates vendor if vendor is not found" do
        company = create(:company)
        expect do
          post :search, params: { project_name: "new project", project: { description: '' }, company: { uen: company.uen, name: company.name, description: company.description }, vendor_name: "new vendor", vendor_uen: 123 }
        end.to change { Company.count }.by(1)
      end

      it "does not create vendor or reviewer if vendor is found" do
        company = create(:company)
        project = create(:project)
        CompanyReviewable.create(company: company, reviewable: project)
        expect do
          post :search, params: { project_name: project.name, project: { description: project.description }, company: { uen: company.uen, name: company.name, description: company.description }, vendor_name: project.companies.first.name, vendor_uen: project.companies.first.uen }
        end.to change { Company.count }.by(0)
      end

      it "creates reviewer if reviewer is not found" do
        company = create(:company)
        project = create(:project)
        CompanyReviewable.create(company: company, reviewable: project)
        expect do
          post :search, params: { project_name: project.name, project: { description: project.description }, company: { uen: 123, name: "aname", description: "adesc" }, vendor_name: project.companies.first.name, vendor_uen: project.companies.first.uen }
        end.to change { Company.count }.by(1)
      end

      it "seaches by uen" do
        project = create(:project)
        reviewer = create(:company)
        CompanyReviewable.create(company: reviewer, reviewable: project)
        post :search, params: { project_name: project.name, project: { description: project.description }, company: { uen: reviewer.uen, name: "aname", description: "adesc" }, vendor_name: "wrong", vendor_uen: project.companies.first.uen }
        expect(response).to be_success
      end

      it "searches by name if uen is not found" do
        project = create(:project)
        reviewer = create(:company)
        CompanyReviewable.create(company: reviewer, reviewable: project)
        post :search, params: { project_name: project.name, project: { description: project.description }, company: { uen: 123, name: reviewer.name, description: "adesc" }, vendor_name: project.companies.first.name, vendor_uen: 321 }
        expect(response).to be_success
      end

      it "searches by name if uen is blank" do
        project = create(:project)
        reviewer = create(:company)
        CompanyReviewable.create(company: reviewer, reviewable: project)
        post :search, params: { project_name: project.name, project: { description: project.description }, company: { uen: "", name: reviewer.name, description: "adesc" }, vendor_name: project.companies.first.name, vendor_uen: "" }
        expect(response).to be_success
      end

      it "can submit multiple blanks" do
        project = build(:project)

        expect do
          expect do
            post :search, params: { project_name: project.name, project: { description: project.description }, company: { uen: "", name: "aname", description: "adesc" }, vendor_name: "bname", vendor_uen: "" }
            post :search, params: { project_name: project.name, project: { description: project.description }, company: { uen: "", name: "abname", description: "adesc" }, vendor_name: "vname", vendor_uen: "" }
          end.to change { Company.count }.by(4)
        end.to change { Project.count }.by(1)
      end

      it "returns a success response" do
        post :search, params: { project_name: 'test', project: { description: 'for test' }, company: { uen: 999, name: 'test', description: 'for test' }, vendor_name: "abc", vendor_uen: 123 }
        expect(response).to be_success
      end

      it "requires vendor name and uen" do
        post :search, params: { project_name: 'test', project: { description: 'for test' }, company: { uen: 999, name: 'test', description: 'for test' } }
        expect(response.status).to eq(404)
      end

      it "returns a unprocessable_entity response when company creation failed" do
        post :search, params: { project_name: 'test', company: { uen: 999, name: '', description: '' }, vendor_name: "abc", vendor_uen: 123 }
        expect(response.status).to eq(422)
      end

      it "returns a company when company uen is found" do
        create(:company, uen: "999")
        post :search, params: { project_name: 'test', project: { description: 'test' }, company: { uen: 999, name: '', description: '' }, vendor_name: "abc", vendor_uen: 123 }
        expect(response).to be_success
      end

      it "returns a company when company uen is not found but name is found" do
        create(:company, name: "tEst name", uen: "999")
        post :search, params: { project_name: 'test', project: { description: 'test' }, company: { uen: 888, name: '  Test NaMe   ', description: '' }, vendor_name: "abc", vendor_uen: 123 }
        expect(response).to be_success
      end
    end
  end

  describe "Unauthorised user" do
    describe "GET #index" do
      it "returns an unauthorized response", authorized: false do
        get :index, params: { company_id: @project.companies.first.hashid }

        expect_unauthorized
      end
    end

    describe "GET #show" do
      it "returns an unauthorized response", authorized: false do
        get :show, params: { id: @project.to_param }

        expect_unauthorized
      end
    end

    describe "POST #create" do
      it "does not create a new Project", authorized: false do
        company = create(:company)

        expect do
          post :create, params: { project: valid_attributes, company_id: company.id }
        end.to change(Project, :count).by(0)
      end

      it "returns an unauthorized response", authorized: false do
        company = create(:company)

        post :create, params: { project: valid_attributes, company_id: company.id }
        expect_unauthorized
      end
    end

    describe "PUT #update" do
      let(:new_attributes) do
        attributes_for(:project)
      end

      it "does not update the requested project", authorized: false do
        current_attributes = @project.attributes

        put :update, params: { id: @project.to_param, project: new_attributes }, session: valid_session
        @project.reload
        expect(@project.name).to eq(current_attributes["name"])
        expect(@project.description).to eq(current_attributes["description"])
      end

      it "returns an unauthorized response", authorized: false do
        put :update, params: { id: @project.to_param, project: valid_attributes }, session: valid_session
        expect_unauthorized
      end
    end

    describe "DELETE #destroy" do
      it "does not destroy the requested project", authorized: false do
        expect do
          delete :destroy, params: { id: @project.to_param }, session: valid_session
        end.to change(Project, :count).by(0)
      end

      it "does not set discarded_at datetime", authorized: false do
        delete :destroy, params: { id: @project.to_param }
        @project.reload
        expect(@project.discarded?).to be false
      end
      it "returns an unauthorized response", authorized: false do
        delete :destroy, params: { id: @project.to_param }, session: valid_session
        expect_unauthorized
      end
    end
  end
end
