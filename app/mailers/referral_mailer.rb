class ReferralMailer < ActionMailer::Base
  default from: "from@example.com"
  def send_referral(referral)
    @ref = referral
    mail(to: @ref.email, subject: "Invitation to Sign Up")
  end
end
