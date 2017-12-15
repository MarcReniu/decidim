# frozen_string_literal: true

require_dependency "decidim/admin/application_controller"

module Decidim
  module Admin
    # Controller that allows managing managed users at the admin panel.
    #
    class ManagedUsersController < Admin::ApplicationController
      layout "decidim/admin/users"

      def index
        authorize! :index, :managed_users
        @managed_users = collection.page(params[:page]).per(15)
      end

      def new
        authorize! :new, :managed_users

        @form = form(ManagedUserForm).from_params(params)
      end

      def create
        authorize! :create, :managed_users

        @form = form(ManagedUserForm).from_params(params)

        CreateManagedUser.call(@form) do
          on(:ok) do
            flash[:notice] = I18n.t("managed_users.create.success", scope: "decidim.admin")
            redirect_to managed_users_path
          end

          on(:invalid) do
            flash.now[:alert] = I18n.t("managed_users.create.error", scope: "decidim.admin")
            render :new
          end
        end
      end

      private

      def collection
        @collection ||= current_organization.users.managed
      end
    end
  end
end
