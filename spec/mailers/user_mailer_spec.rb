require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
   describe "confirmation email" do
    let(:user) { create(:user) }
    let(:params) { {user: user} }
    let(:mail) { described_class.with(user: user).confirmation_email.deliver_now }

    it "renders the headers" do
      expect(mail.subject).to eq("Registration Confirmation")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["notifications@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Welcome to IOT.com")
      expect(mail.body.encoded).to match("To confirm your registration click the URL below")
      expect(mail.body.encoded).to match(user.verification_code)
      expect(mail.body.encoded).to match(user.email)
    end
  end
end
