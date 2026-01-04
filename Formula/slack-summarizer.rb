class SlackSummarizer < Formula
  desc "Comprehensive Slack activity summarization CLI"
  homepage "https://github.com/hansef/slack-summarizer"
  url "https://github.com/hansef/slack-summarizer/releases/download/v1.0.0/slack-summarizer-macos-arm64.tar.gz"
  sha256 "0be8be8a84777c94f532039b0fb110fe3915432a13a9c2192cec3fbfdea34158"
  version "1.0.0"
  license "MIT"

  depends_on :macos
  depends_on arch: :arm64
  depends_on "node@20"

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
