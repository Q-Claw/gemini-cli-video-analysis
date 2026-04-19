---
name: gemini-cli-video-analysis
description: Analyze local video files with Gemini CLI, using reliable multimodal file injection and a clean workspace copy to avoid path/ignore issues.
version: 1.0.0
author: TypQxQ
license: MIT
homepage: https://github.com/TypQxQ/gemini-cli-video-analysis
metadata:
  hermes:
    tags:
      - video
      - media
      - multimodal
      - analysis
      - gemini-cli
---

# Gemini CLI Video Analysis

Use this skill when you need to analyze a **local video file** and Gemini CLI is available/configured on the machine.

## When to use
- The user asks to analyze a video, summarize a clip, describe what happens, extract a timeline, or review pacing/storytelling.
- A local `.mp4`, `.mov`, `.webm`, or similar video file is available.
- Prefer this path over frame-by-frame manual extraction when Gemini CLI can directly ingest the video.

## When not to use
- The video file is not locally accessible or the attachment failed to download.
- Gemini CLI authentication or configuration is broken. In that case, fix the provider setup first.

## Why this path
Gemini CLI supports multimodal file injection for **video**, and can often answer directly from the video without a separate FFmpeg frame-extraction step.

## Critical pitfalls
1. **Use `@{...}` syntax, not bare `@path`**
   - Correct:
     ```bash
     gemini -p 'Describe this video: @{./video.mp4}'
     ```
   - Risky / often wrong:
     ```bash
     gemini -p 'Describe this video: @./video.mp4'
     ```

2. **Video must be inside Gemini's allowed workspace**
   - If the source file is outside the current workspace, Gemini CLI can refuse it.
   - Reliable fix: copy the video into a clean working directory and run Gemini from there.

3. **Avoid git-ignored/temp directories**
   - Gemini CLI may skip multimodal files in ignored paths such as some `tmp/` folders.
   - If a video is skipped, move/copy it into a normal non-ignored directory and retry.

## Fast workflow
1. Confirm `gemini` exists:
   ```bash
   which gemini
   gemini --version
   ```
2. Create or reuse a clean workspace, e.g.:
   ```bash
   mkdir -p ~/.gemini/video-analysis-workspace
   ```
3. Copy the video there.
4. Source your Gemini environment file if needed.
5. Run Gemini with `@{./file.ext}`.

## Recommended command pattern
```bash
WORKDIR="$HOME/.gemini/video-analysis-workspace"
mkdir -p "$WORKDIR"
cp /path/to/video.mp4 "$WORKDIR/"
cd "$WORKDIR"
gemini -p 'Analyze this video. Describe what happens, key objects/actions, any visible text, and provide a short timeline: @{./video.mp4}' --output-format text --approval-mode yolo
```

## Good prompts

### 1) General summary
```bash
gemini -p 'Summarize this video and describe the important events: @{./video.mp4}' --output-format text --approval-mode yolo
```

### 2) Detailed analysis
```bash
gemini -p 'Analyze this video in detail. Describe scene by scene, key actions, visible text, notable transitions, and anything important for a reviewer to know: @{./video.mp4}' --output-format text --approval-mode yolo
```

### 3) Timeline
```bash
gemini -p 'Create a timeline for this video with approximate timestamps and what happens in each segment: @{./video.mp4}' --output-format text --approval-mode yolo
```

### 4) Creative/social review
```bash
gemini -p 'Review this video like a content strategist. Evaluate hook, pacing, transitions, clarity, emotional pull, and how it could be improved for social media: @{./video.mp4}' --output-format text --approval-mode yolo
```

## Preferred helper script
If available, use the bundled helper script in this repository:
- `scripts/gemini-video-analyze.sh`

Example:
```bash
./scripts/gemini-video-analyze.sh /path/to/video.mp4
./scripts/gemini-video-analyze.sh /path/to/video.mp4 'Review pacing, captions, and transitions for Instagram Reels.'
```

## Verification checklist
- Gemini CLI exists and returns a version.
- Prompt uses `@{...}`.
- Video is inside a non-ignored workspace.
- Gemini returns an answer about the video rather than a path/permission/ignored-file error.

## Fallbacks
- If Gemini says the path is outside workspace → copy into clean workspace and retry.
- If Gemini says the file is ignored → move/copy to non-ignored workspace and retry.
- If Gemini auth fails → run provider setup or login.

## Response pattern to user
After running the analysis:
1. Give a concise summary first.
2. Then provide the requested structure (timeline, critique, transcript-style notes, etc.).
3. Mention any limitations explicitly, e.g. uncertain audio/transcript details.