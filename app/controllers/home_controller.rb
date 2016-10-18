class HomeController < ApplicationController
  before_filter :authenticate_user!, only: [:match_preference, :confirm]
  caches_action :index, :about, :privacy_policy, :terms,
    unless: :user_signed_in?, cache_path: lambda { |c| c.request.original_url }

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

  def privacy_policy
  end

  def terms
  end
end
