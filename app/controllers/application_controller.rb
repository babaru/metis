class ApplicationController < ActionController::Base
  include ::Tida::Metis::SpaceHelper
  protect_from_forgery

  layout :layout_by_resource
  before_filter :initialize_sessions, :get_space
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

  def get_space
    if current_user && current_user.is_sys_admin?
      @space = Space.find params[:space_id] if params[:space_id]
      @space = Space.first
    else
      @space = current_space
    end
  end
end
