require 'rails_helper'

describe AccessToken do
  let(:authorization) { Authorization.new }

  subject { authorization.access_tokens.new }

  context "valid_token?" do
    specify "token is valid" do
      subject.created_at = Time.now
      expect(subject).to be_valid_token
    end

    specify "token out of date" do
      subject.created_at = 2.hours.ago
      expect(subject).to_not be_valid_token
    end

    specify "token no longer active" do
      subject.active = false
      expect(subject).to_not be_valid_token
    end

    specify "authorization no longer active" do
      authorization.active = false
      subject.created_at = Time.now
      expect(subject).to_not be_valid_token
    end
  end
end
