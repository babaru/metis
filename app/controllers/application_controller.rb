class ApplicationController < ActionController::Base
  include ::Tida::Metis::SpaceHelper
  protect_from_forgery

  layout :layout_by_resource
  before_filter :initialize_sessions
  add_breadcrumb '控制台', '/'

  protected

  def layout_by_resource
    if devise_controller?
      "single"
    else
      "application"
    end
  end

  def initialize_sessions
    session[:spot_picker] = {} unless session[:spot_picker]
  end
end
