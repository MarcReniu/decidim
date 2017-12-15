# frozen_string_literal: true

module Decidim
  module Admin
    # A command with all the business logic to create a new managed user in the
    # admin panel.
    class CreateManagedUser < Rectify::Command
      # Public: Initializes the command.
      #
      # form - A form object with the params.
      def initialize(form)
        @form = form
      end

      # Executes the command. Broadcasts these events:
      #
      # - :ok when everything is valid.
      # - :invalid if the form wasn't valid and we couldn't proceed.
      #
      # Returns nothing.
      def call
        return broadcast(:invalid) if form.invalid?

        create_managed_user

        broadcast(:ok)
      end

      private

      attr_reader :form

      def create_managed_user
        @user = Decidim::User.create!(
          name: form.name,
          organization: form.current_organization,
          admin: false,
          managed: true,
          tos_agreement: true
        )
      end
    end
  end
end
