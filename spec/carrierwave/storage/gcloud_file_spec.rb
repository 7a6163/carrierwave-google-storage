require "spec_helper"

describe CarrierWave::Storage::GcloudFile do
  let(:path) { "files/1/file.txt" }
  let(:file) { double(:file, content_type: "content/type", path: "/file/path") }
  let(:bucket) { double(:bucket, object: file) }
  let(:connection) { double(:connection, bucket: bucket) }

  let(:uploader) { FeatureUploader.new }

  subject(:gcloud_file) do
    CarrierWave::Storage::GcloudFile.new(uploader, connection, path)
  end

  describe "#to_file" do
    it "returns the internal file instance" do
      file = Object.new
      gcloud_file.file = file

      expect(gcloud_file.to_file).to(be(file))
    end
  end

  describe "#extension" do
    it "extracts the file extension from the path" do
      gcloud_file.path = "file.txt"

      expect(gcloud_file.extension).to(eq("txt"))
    end

    it "is nil if the file has no extension" do
      gcloud_file.path = "filetxt"

      expect(gcloud_file.extension).to(be_nil)
    end
  end

  describe "#bucket" do
    it "returns the internal bucket instance" do
      expect(gcloud_file.send(:bucket)).to(be(bucket))
    end
  end

  describe "#url" do
    let(:options) { {} }

    context("when gcloud_bucket_is_public is false") do
      before { allow(uploader).to(receive(:gcloud_bucket_is_public).and_return(false)) }

      it "calls authenticated_url method" do
        expect(gcloud_file).to(receive(:authenticated_url).with(options))

        gcloud_file.url(options)
      end
    end

    context("when gcloud_bucket_is_public is true") do
      before { allow(uploader).to(receive(:gcloud_bucket_is_public).and_return(true)) }

      it "calls public_url method" do
        expect(gcloud_file).to(receive(:public_url))

        gcloud_file.url
      end
    end
  end

  describe "#authenticated_url" do
    before { allow(uploader).to(receive(:gcloud_authenticated_url_expiration).and_return(60)) }

    it "calls #signed_url with the expires option" do
      expect(bucket).to(receive(:signed_url).with(path, {expires: 60}))

      gcloud_file.authenticated_url
    end

    context("when HMAC credentials are configured") do
      before do
        allow(uploader).to(receive(:gcloud_hmac_access_id).and_return("GOOG1EXAMPLE"))
        allow(uploader).to(receive(:gcloud_hmac_secret).and_return("hmac-secret"))
      end

      it "forwards issuer and signing_key to #signed_url" do
        expect(bucket).to(
          receive(:signed_url).with(
            path,
            {issuer: "GOOG1EXAMPLE", signing_key: "hmac-secret", expires: 60}
          )
        )

        gcloud_file.authenticated_url
      end

      it "lets per-call options override the configured HMAC values" do
        expect(bucket).to(
          receive(:signed_url).with(
            path,
            {issuer: "GOOG1OVERRIDE", signing_key: "override-secret", expires: 60}
          )
        )

        gcloud_file.authenticated_url(
          issuer: "GOOG1OVERRIDE",
          signing_key: "override-secret"
        )
      end
    end

    context("when HMAC credentials are not configured") do
      before do
        allow(uploader).to(receive(:gcloud_hmac_access_id).and_return(nil))
        allow(uploader).to(receive(:gcloud_hmac_secret).and_return(nil))
      end

      it "does not pass issuer or signing_key to #signed_url" do
        expect(bucket).to(receive(:signed_url).with(path, {expires: 60}))

        gcloud_file.authenticated_url
      end
    end

    context("when only gcloud_hmac_access_id is set") do
      before do
        allow(uploader).to(receive(:gcloud_hmac_access_id).and_return("GOOG1ONLY_ID"))
        allow(uploader).to(receive(:gcloud_hmac_secret).and_return(nil))
      end

      it "raises ArgumentError to surface the misconfiguration" do
        expect { gcloud_file.authenticated_url }
          .to(raise_error(ArgumentError, /gcloud_hmac_access_id and gcloud_hmac_secret must both be set/))
      end
    end

    context("when only gcloud_hmac_secret is set") do
      before do
        allow(uploader).to(receive(:gcloud_hmac_access_id).and_return(nil))
        allow(uploader).to(receive(:gcloud_hmac_secret).and_return("only-secret"))
      end

      it "raises ArgumentError to surface the misconfiguration" do
        expect { gcloud_file.authenticated_url }
          .to(raise_error(ArgumentError, /gcloud_hmac_access_id and gcloud_hmac_secret must both be set/))
      end
    end

    context("when HMAC credentials are empty strings") do
      before do
        allow(uploader).to(receive(:gcloud_hmac_access_id).and_return(""))
        allow(uploader).to(receive(:gcloud_hmac_secret).and_return(""))
      end

      it "treats them as unset and does not pass issuer or signing_key" do
        expect(bucket).to(receive(:signed_url).with(path, {expires: 60}))

        gcloud_file.authenticated_url
      end
    end
  end
end
