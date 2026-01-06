class SlackSummarizer < Formula
  desc "Comprehensive Slack activity summarization CLI"
  homepage "https://github.com/hansef/slack-summarizer"
  url "https://github.com/hansef/slack-summarizer/releases/download/v1.2.1/slack-summarizer-macos-arm64.tar.gz"
  sha256 "dc809979e6dd1f93f0b9c2fbe32fcad8f1fdca6efcd8bda064457aef96b8f00c"
  version "1.2.1"
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

      GETTING STARTED
      ───────────────
      Just run:
        $ slack-summarizer

      The interactive TUI will guide you through setup on first run.

      You'll need:
        - Slack user token (xoxp-...) from your Slack app
        - Anthropic API key (sk-ant-...) from console.anthropic.com
          OR Claude OAuth token (for Pro/Max subscribers)

      BATCH MODE
      ──────────
      For scripting or CI/CD, use batch mode:
        $ slack-summarizer --batch

      Or set environment variables:
        export SLACK_USER_TOKEN="xoxp-..."
        export ANTHROPIC_API_KEY="sk-ant-..."

      Config file: ~/.config/slack-summarizer/config.toml

      DOCUMENTATION
      ─────────────
      https://github.com/hansef/slack-summarizer
    EOS
  end

  test do
    assert_match "Summarize Slack activity", shell_output("#{bin}/slack-summarizer --help")
  end
end
