require "rails_helper"

RSpec.describe UserMailer, type: :mailer do

  describe "confirmation email" do
    let(:user) { create(:user) }
    let(:params) { {user: user} }
    let(:mail) { described_class.with(user: user).confirmation_email.deliver_now }

    it "renders the headers" do
      expect(mail.subject).to eq("Confirmación de registro en WAICO")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["waico@waico.com.co"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Bienvenido a WAICO")
      expect(mail.body.encoded).to match("Para terminar su proceso de registro, por favor utilice el siguient")
      expect(mail.body.encoded).to match(user.verification_code)
      expect(mail.body.encoded).to match(user.first_name)
    end
  end

  describe "#update_confirmation" do
    let(:user) { create(:user) }
    let(:params) { {user: user} }
    let(:mail) { described_class.with(user: user).update_confirmation.deliver_now }

    it "renders the headers" do
      expect(mail.subject).to eq("Update Confirmation")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["waico@waico.com.co"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi, #{user.first_name}!")
      expect(mail.body.encoded).to match(user.verification_code)
    end
  end

  describe "#recovery_email" do
    let(:user) { create(:user) }
    let(:params) { {user: user} }
    let(:mail) { described_class.with(user: user).recovery_email.deliver_now }

    it "renders the headers" do
      expect(mail.subject).to eq("Password Recovery")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["waico@waico.com.co"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Someone has requested a link to change your password, and you can do this through the link below.")
      expect(mail.body.encoded).to match(user.email)
    end
  end
end
