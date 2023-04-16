class UsersController < ApplicationController
  before_action :authenticate_user!
  respond_to :html, :json

  def show
    render_user_params = current_user.admin? ? admin_user_params : user_params
    respond_to do |format|
      format.html
      format.json { render json: {users: render_user_params }, status: :ok }
    end
  end

  private
    def admin_user_params
      user_params =[]
      current_user.referrals.each do |ref|
        temp = {
          email: ref.email,
          status: ref.status,
          resend_invite_url: {
            method: "PATCH",
            url: resend_invite_referral_url(ref.id)
          },
        }
        user_params << temp
      end
      user_params
    end

    def user_params
      user_params = [
        {
          fname: current_user.firstname,
          lname: current_user.lastname,
          email: current_user.email,
          referred_by: current_user.referrer.try(:firstname)
        }
      ]
    end

end