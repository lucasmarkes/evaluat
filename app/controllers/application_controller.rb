class ApplicationController < ActionController::Base
  def render_not_found
    render status: :not_found, template: 'errors/not_found'
  end
end
