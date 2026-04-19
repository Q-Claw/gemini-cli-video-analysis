# Gemini CLI Video Analysis Repo Implementation Plan

> **For Hermes:** Use Gemini CLI to implement this repo task-by-task, keeping the repo provider-agnostic where possible and preserving the practical pitfalls discovered during live testing.

**Goal:** Create a standalone GitHub repository for the `gemini-cli-video-analysis` skill, polish it for public sharing, and push it to GitHub.

**Architecture:** Build a small documentation-first repo containing a share-ready `SKILL.md`, a reusable shell helper script, a README with rationale and usage, and lightweight metadata such as license and gitignore. Start from the local Hermes skill, then improve/generalize it with Gemini CLI.

**Tech Stack:** Markdown, Bash, git, GitHub CLI/API, Gemini CLI.

---

### Task 1: Create the standalone repo workspace

**Objective:** Prepare a clean project directory with planning/docs structure.

**Files:**
- Create: `docs/plans/2026-04-19-shareable-repo.md`
- Create: repo root files and directories as needed

**Step 1: Create repo directory**

Run: `mkdir -p /home/andrei/projects/gemini-cli-video-analysis/docs/plans /home/andrei/projects/gemini-cli-video-analysis/scripts`

**Step 2: Verify directory exists**

Run: `pwd` and inspect the target path.

### Task 2: Seed the repo with the current local skill content

**Objective:** Bring over the existing skill/script as starting material.

**Files:**
- Create: `SKILL.md`
- Create: `scripts/gemini-video-analyze.sh`

**Step 1: Copy the current local skill content into the new repo**

Use the local Hermes skill as source material.

**Step 2: Copy the current helper script into the new repo**

Use the existing `gemini-video-analyze.sh` as source material.

### Task 3: Use Gemini CLI to improve and generalize the repo

**Objective:** Have Gemini CLI rewrite the seed files into a shareable public repo.

**Files:**
- Modify: `SKILL.md`
- Modify: `scripts/gemini-video-analyze.sh`
- Create: `README.md`
- Create: `LICENSE`
- Create: `.gitignore`

**Step 1: Run Gemini CLI in the repo root**

Ask Gemini CLI to:
- improve the skill for public sharing
- reduce unnecessary machine-specific assumptions
- keep the real pitfalls (`@{...}`, workspace, ignored paths)
- create a high-quality README
- make the script more configurable and documented

**Step 2: Review the resulting files**

Check that the repo remains practical and not over-engineered.

### Task 4: Verify the generated repo

**Objective:** Confirm the script and docs are internally consistent.

**Files:**
- Verify: `scripts/gemini-video-analyze.sh`
- Verify: `README.md`
- Verify: `SKILL.md`

**Step 1: Run shell syntax check**

Run: `bash -n scripts/gemini-video-analyze.sh`

**Step 2: Inspect key docs**

Read the top of `README.md` and `SKILL.md`.

**Step 3: Ensure executable permissions**

Run: `chmod +x scripts/gemini-video-analyze.sh`

### Task 5: Initialize git and create the GitHub repo

**Objective:** Commit the polished repo and publish it under the user's GitHub account.

**Files:**
- Create: `.git/` metadata

**Step 1: Initialize git and commit**

Run standard `git init`, `git add .`, `git commit -m 'feat: create shareable Gemini CLI video analysis skill repo'`.

**Step 2: Create the remote repo**

Prefer `gh repo create` if authenticated; otherwise use the GitHub API with `GITHUB_TOKEN` from `~/.hermes/.env`.

**Step 3: Push**

Push `main` to origin and verify the remote exists.

### Task 6: Mirror useful improvements back into the local Hermes skill

**Objective:** Keep the installed skill aligned with the polished standalone repo.

**Files:**
- Modify: local Hermes skill files if the public repo version is materially better

**Step 1: Compare the new repo files with the installed skill**

If the public version is better, update the local skill accordingly.
