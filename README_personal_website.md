# Won Jun Lee Personal Website

This folder contains a static personal resume website.

## Files

```text
.
├── index.html
├── resume_web.css
└── WonJunLee_Resume.pdf   # optional; add this if you want the "Download Resume PDF" link to work
```

## Local preview

Open `index.html` directly in your browser.

Or run a small local server:

```bash
python3 -m http.server 8000
```

Then open:

```text
http://localhost:8000
```

## GitHub Pages deployment

### Option A: User site

1. Create a GitHub repository named:

```text
YOUR_GITHUB_USERNAME.github.io
```

2. Put these files at the root of the repository:

```text
index.html
resume_web.css
WonJunLee_Resume.pdf
```

3. Push to GitHub:

```bash
git init
git add index.html resume_web.css WonJunLee_Resume.pdf
git commit -m "Create personal website"
git branch -M main
git remote add origin https://github.com/YOUR_GITHUB_USERNAME/YOUR_GITHUB_USERNAME.github.io.git
git push -u origin main
```

4. Open:

```text
https://YOUR_GITHUB_USERNAME.github.io/
```

### Option B: Project site

1. Create a repository, for example:

```text
personal-website
```

2. Put the files at the root.

3. Go to:

```text
Repository → Settings → Pages
```

4. Under "Build and deployment", select:

```text
Source: Deploy from a branch
Branch: main
Folder: /root
```

5. Your site will usually become:

```text
https://YOUR_GITHUB_USERNAME.github.io/personal-website/
```

## Netlify deployment

1. Push this folder to GitHub.
2. Go to Netlify.
3. Choose "Add new site" or "Import from Git".
4. Connect the GitHub repository.
5. Since this is plain static HTML/CSS:
   - Build command: leave empty
   - Publish directory: `.`
6. Deploy.

## Updating the website

Edit `index.html` and `resume_web.css`, then push again:

```bash
git add index.html resume_web.css
git commit -m "Update website"
git push
```

If the site links to `WonJunLee_Resume.pdf`, replace the PDF file and commit it too.

## Notes

- Keep private information out of public repositories.
- If you do not want your phone number public, remove it from `index.html`.
- If you later want a more advanced academic website, add separate pages such as `research.html`, `publications.html`, and `projects.html`.
