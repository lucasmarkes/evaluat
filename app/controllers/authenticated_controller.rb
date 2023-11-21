class AuthenticatedController < ApplicationController
  layout "dashboard"

  before_action :authenticate_user!

  private

  def admin_only
    render status: :not_found, template: 'errors/not_found' unless current_user.admin?
  end

  def student_only
    render status: :not_found, template: 'errors/not_found' unless current_user.student?
  end
end
