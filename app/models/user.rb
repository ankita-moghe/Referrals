class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: [:admin, :referral]

  after_commit :post_commit_hook, on: :create

  has_many :referrals

  def send_referral_email(email)
    referral = self.referrals.find_or_initialize_by(email: email)
    count = referral.resend_count.nil? ? 0 : referral.resend_count += 1
    referral.resend_count = count
    referral.status = "pending"
    referral.save
    ReferralMailer.send_referral(referral).deliver_now
  end


  def post_commit_hook
    ref = find_referral
    return if ref.nil?
    ref.update(status: "accepted")
  end

  def referrer
    find_referral.try(:user)
  end

  private

  def find_referral
    Referral.find_by(email: self.email)
  end
end
