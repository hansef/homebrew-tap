# Homebrew formula for slack-summarizer
# Copy this file to your homebrew-tap repository: Formula/slack-summarizer.rb
#
# Installation: brew tap hansef/tap && brew install slack-summarizer
#
# To update the formula after a new release:
# 1. Create a GitHub release with tag vX.Y.Z
# 2. Download the tarball: wget https://github.com/hansef/slack-summarizer/archive/refs/tags/vX.Y.Z.tar.gz
# 3. Calculate SHA256: shasum -a 256 vX.Y.Z.tar.gz
# 4. Update the url and sha256 below

class SlackSummarizer < Formula
  desc "Comprehensive Slack activity summarization CLI"
  homepage "https://github.com/hansef/slack-summarizer"
  url "https://github.com/hansef/slack-summarizer/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "PLACEHOLDER_SHA256_UPDATE_AFTER_RELEASE"
  license "MIT"

  depends_on "node@20"
  depends_on "pnpm" => :build

  def install
    # Use the Homebrew-installed Node.js
    ENV.prepend_path "PATH", Formula["node@20"].opt_bin

    # Install dependencies (production only would miss devDeps needed for build)
    system "pnpm", "install", "--frozen-lockfile"

    # Build TypeScript
    system "pnpm", "build"

    # Copy built files to libexec
    libexec.install Dir["dist/*"]
    libexec.install "node_modules"
    libexec.install "package.json"

    # Copy the SQL schema file (needed at runtime by db.ts)
    # The loader reads from __dirname which will be libexec/cli when running
    # So we need to match the relative path from dist/core/cache/
    mkdir_p libexec/"core/cache"
    cp "src/core/cache/schema.sql", libexec/"core/cache/schema.sql"

    # Create wrapper script
    (bin/"slack-summarizer").write <<~EOS
      #!/bin/bash
      exec "#{Formula["node@20"].opt_bin}/node" "#{libexec}/cli/index.js" "$@"
    EOS
  end

  def caveats
    <<~EOS
      Slack Summarizer has been installed!

      FIRST-TIME SETUP
      ────────────────
      Run the interactive configuration wizard:
        $ slack-summarizer configure

      You'll need:
        • Slack user token (xoxp-...) from your Slack workspace
        • Anthropic API key (sk-ant-...) from console.anthropic.com

      CONFIGURATION
      ─────────────
      Config file: ~/.config/slack-summarizer/config.toml

      You can also use environment variables:
        export SLACK_USER_TOKEN="xoxp-..."
        export ANTHROPIC_API_KEY="sk-ant-..."

      QUICK START
      ───────────
      1. Configure:  slack-summarizer configure
      2. Test:       slack-summarizer test-connection
      3. Summarize:  slack-summarizer summarize

      DOCUMENTATION
      ─────────────
      https://github.com/hansef/slack-summarizer
    EOS
  end

  test do
    assert_match "Summarize Slack activity", shell_output("#{bin}/slack-summarizer --help")
    assert_match version.to_s, shell_output("#{bin}/slack-summarizer --version")
  end
end
