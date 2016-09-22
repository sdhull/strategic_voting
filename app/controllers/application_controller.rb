class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  caches_action :index, :about, :privacy_policy, :terms, unless: :user_signed_in?

  protected

  def after_sign_up_path_for(resource)
    confirm_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:state, :desired_candidate, :name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:state, :desired_candidate, :name])
  end
end
