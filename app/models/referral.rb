class Referral < ApplicationRecord
  
  MAX_RESEND_COUNT = 5
	belongs_to :user

	enum status: [:pending, :accepted]
	validate :resend_invite_count, if: lambda { |ref| ref.pending? }, on: :update


	private

	  def resend_invite_count
	  	errors.add(:resend_invite_count, "should be less than #{MAX_RESEND_COUNT}") if self.resend_count > 5
	  end
end