#!/usr/bin/env bash
set -euo pipefail

COPIED_VIDEO=""

cleanup() {
  if [[ -n "$COPIED_VIDEO" && -f "$COPIED_VIDEO" ]]; then
    rm -f "$COPIED_VIDEO"
  fi
}

trap cleanup EXIT

show_help() {
  cat << EOF
Usage: $(basename "$0") [OPTIONS] <path_to_video> [custom_prompt]

Analyze a local video file using the Gemini CLI.
This script copies the video to a clean workspace to avoid path and git-ignore
issues that can break multimodal file injection, runs the analysis, and then
removes the temporary copied video.

Options:
  -h, --help    Show this help message and exit

Environment Variables:
  GEMINI_ENV_FILE         Path to an environment file to source (default: ~/.gemini/.env)
  GEMINI_VIDEO_WORKSPACE  Directory to use as the workspace (default: ~/.gemini/video-analysis-workspace)
  GEMINI_APPROVAL_MODE    Approval mode for Gemini CLI (default: yolo; optimized for unattended/agent use)
  GEMINI_OUTPUT_FORMAT    Output format for Gemini CLI (default: text)

Examples:
  $(basename "$0") /path/to/video.mp4
  $(basename "$0") /path/to/video.mp4 "Summarize this video"
EOF
}

if [[ ${1:-} == "-h" ]] || [[ ${1:-} == "--help" ]]; then
  show_help
  exit 0
fi

if [[ $# -lt 1 ]]; then
  echo "Error: Missing video path." >&2
  show_help >&2
  exit 1
fi

VIDEO_PATH="$1"
CUSTOM_PROMPT="${2:-Analyze this video in detail. Describe what happens, key objects/actions, visible text, and provide a short timeline.}"

ENV_FILE="${GEMINI_ENV_FILE:-$HOME/.gemini/.env}"
WORKDIR="${GEMINI_VIDEO_WORKSPACE:-$HOME/.gemini/video-analysis-workspace}"
APPROVAL_MODE="${GEMINI_APPROVAL_MODE:-yolo}"
OUTPUT_FORMAT="${GEMINI_OUTPUT_FORMAT:-text}"

if [[ ! -f "$VIDEO_PATH" ]]; then
  echo "Error: Video not found: $VIDEO_PATH" >&2
  exit 1
fi

if ! command -v gemini >/dev/null 2>&1; then
  echo "Error: gemini CLI not found in PATH" >&2
  exit 1
fi

mkdir -p "$WORKDIR"

ABS_VIDEO_PATH="$(cd "$(dirname "$VIDEO_PATH")" && pwd -P)/$(basename "$VIDEO_PATH")"
BASENAME="$(basename "$ABS_VIDEO_PATH")"
STAMP="$(date +%Y%m%d-%H%M%S)"
COPIED_VIDEO="$WORKDIR/$STAMP-$BASENAME"
cp "$ABS_VIDEO_PATH" "$COPIED_VIDEO"

cd "$WORKDIR"

if [[ -f "$ENV_FILE" ]]; then
  set -a
  source "$ENV_FILE"
  set +a
else
  echo "Warning: Environment file not found at $ENV_FILE, skipping source." >&2
fi

REL_VIDEO="./$(basename "$COPIED_VIDEO")"
PROMPT="$CUSTOM_PROMPT @{${REL_VIDEO}}"

echo "Workspace: $WORKDIR" >&2
echo "Temporary video copy: $COPIED_VIDEO" >&2

gemini -p "$PROMPT" --output-format "$OUTPUT_FORMAT" --approval-mode "$APPROVAL_MODE"
