# Google Play Console Setup Guide

## ✅ Issue: Privacy Policy Required for Camera Permission

### Solution: Add Privacy Policy URL

## Step-by-Step Instructions

### Option 1: Host on GitHub Pages (Recommended - Free)

1. **Create a new GitHub repository:**
   - Go to: https://github.com/new
   - Repository name: `vocality-ai-privacy`
   - Make it **Public**
   - Click "Create repository"

2. **Upload the privacy policy:**
   - Click "uploading an existing file"
   - Upload `privacy-policy.html` from your project folder
   - Commit the file

3. **Enable GitHub Pages:**
   - Go to repository **Settings** → **Pages**
   - Source: Deploy from branch **main**
   - Folder: **/ (root)**
   - Click **Save**
   - Wait 1-2 minutes for deployment

4. **Get your URL:**
   - Your privacy policy will be at: `https://YOUR-USERNAME.github.io/vocality-ai-privacy/privacy-policy.html`
   - Test the URL in your browser to make sure it works

### Option 2: Host on Netlify Drop (Fastest - 30 seconds)

1. Go to: https://app.netlify.com/drop
2. Drag and drop your `privacy-policy.html` file
3. Get instant URL: `https://random-name.netlify.app/privacy-policy.html`
4. Copy this URL

### Option 3: Use GitHub Gist (Quick)

1. Go to: https://gist.github.com/new
2. Filename: `privacy-policy.md`
3. Copy content from `PRIVACY_POLICY_TEMPLATE.md`
4. Update email/contact info
5. Click "Create public gist"
6. Copy the gist URL

---

## Add Privacy Policy to Google Play Console

### Navigate to Privacy Policy Settings

1. **Go to Google Play Console:** https://play.google.com/console
2. **Select your app** (Vocality AI)
3. **Left sidebar:** Click **Policy** → **App content**
4. **Scroll down** to find **"Privacy policy"** section
5. Click **"Start"** or **"Manage"**

### Enter Your Privacy Policy URL

1. **Paste your URL** (from GitHub Pages, Netlify, or Gist)
2. Click **Save**
3. Wait for confirmation

### Verify and Upload App Bundle

1. **Return to release page:** Go to **Release** → **Production** (or Testing)
2. **Create new release** or continue existing one
3. The privacy policy error should now be **gone**
4. **Upload** your `app-release.aab` file from:
   ```
   build/app/outputs/bundle/release/app-release.aab
   ```
5. Complete the release form and submit

---

## Important URLs to Remember

- **Privacy Policy File:** `privacy-policy.html` (in your project folder)
- **Play Console:** https://play.google.com/console
- **Your Privacy Policy URL:** (Add your hosted URL here after setup)

---

## Troubleshooting

### "Privacy policy URL is not accessible"
- Make sure the URL is **publicly accessible**
- Don't use `localhost` or private URLs
- Test the URL in an incognito browser window

### "Invalid URL format"
- URL must start with `https://` or `http://`
- No spaces in the URL
- Must be a direct link to the policy page

### Still getting camera permission error?
- Ensure you've saved the privacy policy URL in Play Console
- Refresh the release page
- Clear browser cache and try again

---

## Next Steps After Upload

1. ✅ Privacy policy URL added to Play Console
2. ✅ App bundle uploaded successfully
3. ⏳ Complete release notes and screenshots
4. ⏳ Submit for review
5. ⏳ Wait for Google's approval (usually 1-3 days)

---

## File Locations

- Privacy Policy HTML: `/home/sadik/Desktop/Vocality AI/vocality_ai/privacy-policy.html`
- App Bundle: `/home/sadik/Desktop/Vocality AI/vocality_ai/build/app/outputs/bundle/release/app-release.aab`
- This Guide: `/home/sadik/Desktop/Vocality AI/vocality_ai/PLAY_CONSOLE_SETUP.md`
