class ReferralsController < ApplicationController
  before_action :authenticate_user!
	before_action :validate_admin_user
  before_action :find_referral, only: :resend_invite
	def new
	end

  def create
    current_user.send_referral_email(raferral_params["email"])
    respond_to do |format|
      format.html {redirect_to user_path(current_user.id), notice: "Referral sent successfully!"}
      format.json { render json: {message: "Referral sent successfully!" }, status: :created }
    end
  end

  def resend_invite
    if @referral.resend_count < Referral::MAX_RESEND_COUNT && @referral.pending?
      @referral.update(resend_count: @referral.resend_count + 1)
      ReferralMailer.send_referral(@referral).deliver_now
      respond_to do |format|
        format.html {redirect_to user_path, notice: "Resent link successfully!"}
        format.json { render json: {message: "Resent link successfully!" }, status: :created }
      end
    else
      respond_to do |format|
        format.html {redirect_to user_path, notice: "Referral resend count is exahausted."}
        format.json { render json: {message: "Referral resend count is exahausted." }, status: :created }
      end
    end
  end

  private

  def raferral_params
  	params.require(:referrals).permit(:email)
  end

  def validate_admin_user
    current_user = User.find_by(id: 2)
    (render json: {message: "Unauthorized" }, status: :unauthorized and return) unless current_user.admin?
  end

  def find_referral
    @referral = current_user.referrals.find(params["id"])
    (render json: {message: "Not Found" }, status: :unprocessable_entity and return) if @referral.nil?
  end

end