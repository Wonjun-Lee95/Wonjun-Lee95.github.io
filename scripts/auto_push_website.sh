#!/usr/bin/env bash
# Safely commit and push website/resume updates from this local repository.
# Intended for use with macOS launchd; it may also be run manually.

set -Eeuo pipefail

log() {
  printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

fail() {
  log "ERROR: $*"
  exit 1
}

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_CANDIDATE="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
REPO_ROOT="$(git -C "${REPO_CANDIDATE}" rev-parse --show-toplevel 2>/dev/null)" \
  || fail "Could not find a Git repository from ${REPO_CANDIDATE}"

cd "${REPO_ROOT}" || fail "Could not move to repository root: ${REPO_ROOT}"
log "Repository: ${REPO_ROOT}"

if [[ -n "$(git status --porcelain)" ]]; then
  log "Detected uncommitted changes."
else
  log "No uncommitted changes found. Nothing to commit."
  exit 0
fi

# Stage only website/resume files. This avoids accidentally committing temp files,
# editor swap files, build artifacts, or unrelated local notes.
shopt -s nullglob
candidate_files=(
  index.html
  resume_web.css
  WonJunLee_Resume.pdf
  WJLee_Resume.pdf
  WJLEE_Resume.pdf
  README*.md
)
shopt -u nullglob

files_to_add=()
for file in "${candidate_files[@]}"; do
  if [[ -e "${file}" ]]; then
    files_to_add+=("${file}")
  fi
done

if (( ${#files_to_add[@]} == 0 )); then
  log "No allowed website/resume files exist to stage. Nothing to commit."
  exit 0
fi

git add -- "${files_to_add[@]}" \
  || fail "git add failed."

if git diff --cached --quiet; then
  log "Changes exist, but none are in the allowed website/resume files. Nothing to commit."
  exit 0
fi

commit_message="Auto-update website: $(date '+%Y-%m-%d %H:%M')"
log "Creating commit: ${commit_message}"
git commit -m "${commit_message}" \
  || fail "git commit failed."

current_branch="$(git branch --show-current)"
if [[ -z "${current_branch}" ]]; then
  fail "Could not determine current branch. Push skipped."
fi

log "Pushing current branch: ${current_branch}"
git push origin "${current_branch}" \
  || fail "git push failed."

log "Success: committed and pushed website updates."
