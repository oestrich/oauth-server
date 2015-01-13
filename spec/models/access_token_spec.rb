require 'rails_helper'

describe AccessToken do
  subject do
    AccessToken.new
  end

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
  end
end
