# Changelog

All notable changes to this project are documented here. The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and the project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2026-05-05

### Added
- HMAC signed-URL support via two new configuration keys: `gcloud_hmac_access_id` and `gcloud_hmac_secret`. When both are set, `uploader.url` produces a V4 signed URL signed with the HMAC key instead of the service account's RSA private key. Empty strings are treated as unset. Setting only one of the pair raises `ArgumentError` to surface the misconfiguration. Per-call options passed to `uploader.url(...)` continue to override the configured values.
- Ruby 3.3 to the CI matrix.
- A CI cell pairing Ruby 3.3 with `gemfiles/carrierwave-1.gemfile` so CarrierWave 1.x is exercised on a current Ruby. Ruby 2.7 + CarrierWave 1.x is also covered.
- A CI cell pairing Ruby 3.3 with `gemfiles/carrierwave-master.gemfile`.
- Gemspec metadata: `source_code_uri`, `changelog_uri`, `bug_tracker_uri` — surfaces links on rubygems.org.

### Changed
- **BREAKING**: `required_ruby_version` is now `>= 2.7`. Ruby 2.6 and earlier are no longer supported.
- **BREAKING**: `google-cloud-storage` minimum bumped from `~> 1.18` to `~> 1.44`. Apps pinned below 1.44 must update before installing this gem.
- Internal connection bootstrap switched from the legacy `Google::Cloud.new(project, keyfile).storage` entrypoint to `Google::Cloud::Storage.new(project_id:, credentials:)`. Behavior, credential resolution (including ADC fallback), and return type are equivalent.
- Signed URLs now default to V4 (driven by the upstream `google-cloud-storage` upgrade). The previous default in this gem was V2; URL shape and signing algorithm differ between the two.
- CI runs on `ubuntu-latest` (was `ubuntu-20.04`).
- `actions/checkout` upgraded from v3 to v6.
- `gemfiles/carrierwave-1.gemfile` relaxed `multipart-post` from `~> 2.1.0` to `>= 2.1.0` so bundler can resolve a Ruby 3.x-compatible release.

### Removed
- **BREAKING**: Ruby 2.1, 2.2, 2.3, 2.4, 2.5, 2.6 dropped from the CI matrix. The gemspec now refuses to install on those versions.
- Ruby 3.0 and JRuby cells dropped from the CI matrix. The gemspec floor stays at `>= 2.7` (install still works on 3.0), but these combinations are no longer validated on every push.
- The dead `if RUBY_VERSION >= '2.2.2'` activemodel branch in the gemspec; the floor is now `activemodel >= 3.2.0` unconditionally.

## [1.0.0] and earlier

See the project's git history for releases prior to 2.0.0.
