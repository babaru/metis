class ApplicationController < ActionController::Base
  protect_from_forgery

  layout :layout_by_resource
  before_filter :initialize_sessions

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
