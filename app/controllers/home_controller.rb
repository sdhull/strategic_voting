class HomeController < ApplicationController
  def index
    if user_signed_in?
      if !current_user.confirmed?
        redirect_to confirm_path
      elsif current_user.matched?
        @match = current_user.match
        render :your_match
      else
        render :awaiting_match
      end
    end
  end

  def confirm
  end

  def about
  end
end
