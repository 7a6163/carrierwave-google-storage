require "spec_helper"

describe Carrierwave::Google::Storage do

  it "has a version number" do
    expect(Carrierwave::Google::Storage::VERSION).not_to(be(nil))
  end

  it "eagerly loads the Google::Cloud::Storage namespace used by the connection" do
    # Guard against regressing to `require "google-cloud-storage"`, which is
    # only an autoload shim that registers Google::Cloud.storage and does NOT
    # define Google::Cloud::Storage. Storage::Gcloud#connection calls
    # Google::Cloud::Storage.new directly, so the namespace must be loaded
    # eagerly when the gem is required.
    expect(defined?(Google::Cloud::Storage)).to(be_truthy)
    expect(Google::Cloud::Storage).to(respond_to(:new))
  end
end
