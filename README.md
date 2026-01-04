# hansef/homebrew-tap

Homebrew tap for personal tools.

## Installation

```bash
brew tap hansef/tap
```

## Available Formulae

### slack-summarizer

Comprehensive Slack activity summarization CLI.

```bash
brew install slack-summarizer
```

After installation, run the configuration wizard:

```bash
slack-summarizer configure
```

## Cleanup

To completely remove slack-summarizer and its configuration:

```bash
brew uninstall slack-summarizer
rm -rf ~/.config/slack-summarizer
```
