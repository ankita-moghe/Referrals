class HomeController < ApplicationController

  def index
    respond_to do |format|
      format.html
      format.json { render json: {"message": "Welcome to referral_app"} }
    end
  end
end