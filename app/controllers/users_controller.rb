class UsersController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, only: [:create, :update]

  def match_preference
  end

  protected
  # By default we want to require a password checks on update.
  # You can overwrite this method in your own RegistrationsController.
  def update_resource(resource, params)
    if params[:password].present?
      resource.update_with_password(params)
    else
      resource.update_attributes(params)
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:state, :desired_candidate, :name, :phone])
    devise_parameter_sanitizer.permit(:account_update) do |user|
      user.permit :state, :desired_candidate, :name, :phone, :match_strict, match_preference: []
    end
  end

  def after_sign_up_path_for(user)
    flash[:registered] = true
    if user.clinton_voter? && user.safe_state?
      match_preference_path
    else
      confirm_path
    end
  end
end
