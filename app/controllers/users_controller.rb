class UsersController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, only: [:create, :update]
  before_action :authenticate_scope!, only: [:match_preference, :update_match_preference, :edit, :update, :destroy]

  # a special case edit page, only for HRC users
  def match_preference
  end

  def update_match_preference
    pref = params[:pref]
    if ["No Preference", "Jill Stein", "Gary Johnson", "Evan McMullin"].include? pref
      if current_user.update_attribute :match_preference, pref
        if current_user.find_a_match
          redirect_to root_path, notice: "Preference recorded!"
        else
          redirect_to match_preference_path, error: "Preference recorded!"
        end
      else
        redirect_to match_preference_path, error: "Something went wrong, please try again."
      end
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
    if params[:password].present? || params[:current_password].present? || params[:password_confirmation].present?
      resource.update_with_password(params)
    else
      resource.update_attributes(params)
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:state, :desired_candidate, :name, :phone])
    devise_parameter_sanitizer.permit(:account_update) do |user|
      user.permit :current_password,
        :desired_candidate,
        :email,
        :match_strict,
        :name,
        :password,
        :password_confirmation,
        :phone,
        :state,
        match_preference: []
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
