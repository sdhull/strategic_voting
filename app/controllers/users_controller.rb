class UsersController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, only: [:create, :update]
  before_filter :authenticate_user!, only: [:match_preference, :update_match_preference]

  # a special case edit page, only for HRC users
  def match_preference
  end

  def update_match_preference
    pref = params[:pref]
    if ["No Preference", "Jill Stein", "Gary Johnson", "Evan McMullin"].include? pref
      current_user.update_attribute :match_preference, pref
      redirect_to match_preference_path, notice: "Preference recorded!"
    else
      redirect_to match_preference_path, error: "Something went wrong, please try again."
    end
  end

  def login_type
  end

  # GET /users/:id/finish_signup
  # a special case edit page
  def finish_signup
    @user = User.find(params[:id])
  end

  protected

  def user_params
    params.require(:user).permit(:state, :desired_candidate, :phone, :email, :name)
  end

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
