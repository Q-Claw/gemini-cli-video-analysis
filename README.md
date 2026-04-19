# Gemini CLI Video Analysis

A simple, practical tool and Hermes skill for analyzing local video files using the [Gemini CLI](https://github.com/google-gemini/gemini-cli). It correctly handles common pitfalls with multimodal file injection, ensuring reliable video processing.

## Requirements

- A working `gemini` CLI installation
- A Gemini CLI authentication/configuration flow that already works on your machine
- A local video file such as `.mp4`, `.mov`, or `.webm`

## Why this exists

When using the Gemini CLI for video analysis, there are a few common stumbling blocks:
1. **Syntax**: You must use the strict `@{...}` syntax (for example `@{./video.mp4}`), not a bare `@path`.
2. **Workspace constraints**: If a video is outside the current workspace, Gemini CLI may refuse to read it.
3. **Ignored/temp paths**: Gemini CLI can skip multimodal files in `.gitignore`d or temporary directories.

This repository provides:
- a reusable `SKILL.md` for Hermes-style agent workflows
- a small `gemini-video-analyze.sh` helper that copies the video to a clean workspace before analysis

## Usage

Run the helper script directly:

```bash
./scripts/gemini-video-analyze.sh /path/to/video.mp4
```

Provide a custom prompt:

```bash
./scripts/gemini-video-analyze.sh /path/to/video.mp4 "Review the pacing and storytelling of this video."
```

Display help and configuration options:

```bash
./scripts/gemini-video-analyze.sh --help
```

## Configuration

The script behavior can be customized via environment variables:

| Variable | Default | Description |
|---|---|---|
| `GEMINI_ENV_FILE` | `~/.gemini/.env` | Path to an environment file to source before running. |
| `GEMINI_VIDEO_WORKSPACE` | `~/.gemini/video-analysis-workspace` | Clean directory where videos are copied for analysis. |
| `GEMINI_APPROVAL_MODE` | `yolo` | Approval mode passed to Gemini CLI (`--approval-mode`). |
| `GEMINI_OUTPUT_FORMAT` | `text` | Output format passed to Gemini CLI (`--output-format`). |

## Installation

Clone the repository:

```bash
git clone https://github.com/Q-Claw/gemini-cli-video-analysis.git
cd gemini-cli-video-analysis
chmod +x scripts/gemini-video-analyze.sh
```

### Optional: install as a Hermes local skill

```bash
mkdir -p ~/.hermes/skills/media/gemini-cli-video-analysis
cp SKILL.md ~/.hermes/skills/media/gemini-cli-video-analysis/
mkdir -p ~/.hermes/skills/media/gemini-cli-video-analysis/scripts
cp scripts/gemini-video-analyze.sh ~/.hermes/skills/media/gemini-cli-video-analysis/scripts/
chmod +x ~/.hermes/skills/media/gemini-cli-video-analysis/scripts/gemini-video-analyze.sh
```

## License

MIT
