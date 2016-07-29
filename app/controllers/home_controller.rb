class HomeController < ApplicationController
  def index
    if user_signed_in?
      if !current_user.confirmed?
        render :confirm_account
      elsif current_user.matched?
        @match = current_user.match
        render :your_match
      else
        render :awaiting_match
      end
    end
  end

  def about
  end
end
