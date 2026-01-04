class SlackSummarizer < Formula
  desc "Comprehensive Slack activity summarization CLI"
  homepage "https://github.com/hansef/slack-summarizer"
  url "https://github.com/hansef/slack-summarizer/releases/download/v1.0.2/slack-summarizer-macos-arm64.tar.gz"
  sha256 "a7ca2670eadfa6f5d347e4d415ba021e8964135e846d205f6e9024efab807b76"
  version "1.0.2"
  license "MIT"

  depends_on :macos
  depends_on arch: :arm64
  depends_on "node@20"

  # Skip relinking native .node binaries (better-sqlite3, etc.)
  # These are pre-built for the target architecture and don't need modification
  skip_clean :all

  def install
    # Pre-built tarball includes dist/, node_modules/, and package.json
    libexec.install Dir["*"]

    # Create wrapper script that uses Homebrew's Node.js
    (bin/"slack-summarizer").write <<~EOS
      #!/bin/bash
      exec "#{Formula["node@20"].opt_bin}/node" "#{libexec}/dist/cli/index.js" "$@"
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
        - Slack user token (xoxp-...) from your Slack workspace
        - Anthropic API key (sk-ant-...) from console.anthropic.com

      CONFIGURATION
      ─────────────
      Config file: ~/.config/slack-summarizer/config.toml

      You can also use environment variables:
        export SLACK_USER_TOKEN="xoxp-..."
        export ANTHROPIC_API_KEY="sk-ant-..."

      QUICK START
      ───────────
      1. Configure: slack-summarizer configure
      2. Test: slack-summarizer test-connection
      3. Summarize: slack-summarizer summarize

      DOCUMENTATION
      ─────────────
      https://github.com/hansef/slack-summarizer
    EOS
  end

  test do
    assert_match "Summarize Slack activity", shell_output("#{bin}/slack-summarizer --help")
  end
end
