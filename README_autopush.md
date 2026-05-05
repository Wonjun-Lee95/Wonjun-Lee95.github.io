# Website Auto-Push Automation

This repository includes a local macOS automation that can commit and push website/resume updates to GitHub once per day at 10:00 PM local time.

The automation is intentionally narrow: it stages only `index.html`, `resume_web.css`, `WonJunLee_Resume.pdf`, `WJLee_Resume.pdf`, `WJLEE_Resume.pdf`, and `README*.md`. It does not force push, rewrite history, or add temporary files.

## Files

- `scripts/auto_push_website.sh`: checks for changes, creates a timestamped commit, and pushes the current branch.
- `scripts/com.wonjun.website.autopush.plist`: launchd template that runs the script daily at 10:00 PM.

## One-Time Setup

Make the script executable:

```bash
chmod +x scripts/auto_push_website.sh
```

Make sure normal GitHub push authentication already works from Terminal:

```bash
git push
```

If Git asks for credentials during a manual push, set up your preferred GitHub authentication first, such as SSH keys or Git Credential Manager. The launchd job cannot answer interactive prompts.

## Test Manually

Run the script from anywhere inside the repository:

```bash
scripts/auto_push_website.sh
```

If there are no changes, it should print:

```text
No uncommitted changes found. Nothing to commit.
```

If there are website/resume changes, it will create a commit like:

```text
Auto-update website: YYYY-MM-DD HH:MM
```

Then it pushes the current branch with a normal `git push origin <branch>`.

## Install the Daily launchd Job

Copy the plist into your user LaunchAgents directory:

```bash
cp scripts/com.wonjun.website.autopush.plist ~/Library/LaunchAgents/
```

Load and enable the job:

```bash
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.wonjun.website.autopush.plist
launchctl enable gui/$(id -u)/com.wonjun.website.autopush
```

The job is configured to run every day at 10:00 PM local time.

## Test the launchd Job

Trigger it immediately:

```bash
launchctl kickstart -k gui/$(id -u)/com.wonjun.website.autopush
```

Check whether launchd knows about it:

```bash
launchctl print gui/$(id -u)/com.wonjun.website.autopush
```

## Check Logs

Standard output:

```bash
tail -f ~/Library/Logs/website-autopush.log
```

Errors:

```bash
tail -f ~/Library/Logs/website-autopush.err
```

## Unload and Remove

Unload the job:

```bash
launchctl bootout gui/$(id -u) ~/Library/LaunchAgents/com.wonjun.website.autopush.plist
```

Remove the installed plist:

```bash
rm ~/Library/LaunchAgents/com.wonjun.website.autopush.plist
```

The template remains in this repository at `scripts/com.wonjun.website.autopush.plist`.

## Safety Notes

- The script never runs `git push --force`.
- The script never rewrites history.
- The script only stages the website/resume allowlist.
- The launchd job runs locally on this Mac, so it depends on local network access and local GitHub credentials.
