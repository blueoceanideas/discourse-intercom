require 'rails_helper'

describe CurrentUserSerializer do
  let(:user) { Fabricate(:user) }
  let :serializer do
    CurrentUserSerializer.new(user, scope: Guardian.new, root: false)
  end

  before do
    SiteSetting.intercom_enabled = true
    SiteSetting.intercom_secret_key = "ABCDE123"
  end

  it "should add current user email and intercom hash" do
    payload = serializer.as_json
    expect(payload[:external_id]).to eq(user.external_id)
    expect(payload[:intercom_hash]).to be_present
  end

  it "should not add current user email and intercom hash" do
    SiteSetting.intercom_enabled = false
    payload = serializer.as_json
    expect(payload[:external_id]).not_to be_present
    expect(payload[:intercom_hash]).not_to be_present
  end

end
