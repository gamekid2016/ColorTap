# ColorTap - Setup Guide

A simple iOS game where you tap squares to cycle their colour and match the target.

---

## Step 1: Get the project onto your PC

Open a terminal (right-click your desktop > "Open in Terminal" or search for "cmd").

Clone or move the project into a folder you like:

```
git clone https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
```

Or if you're starting fresh, copy this entire ColorTap folder into your repo.

---

## Step 2: Create your GitHub repository

1. Go to https://github.com and click **+** > **New repository**
2. Name it `ColorTap` (or anything you like)
3. Set it to **Private**
4. Click **Create repository**
5. Follow the instructions GitHub shows to push your local folder up

Basic commands to push (run inside the ColorTap folder):

```
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
git push -u origin main
```

---

## Step 3: Add your signing secrets to GitHub

GitHub needs your certificate and provisioning profile to sign the IPA.
You add these as **Secrets** so they are never visible publicly.

### Convert your .p12 to base64

In your terminal (on Windows use Git Bash or PowerShell):

```bash
# Git Bash / Mac / Linux:
base64 -i YourCertificate.p12 -o certificate_base64.txt

# PowerShell on Windows:
[Convert]::ToBase64String([IO.File]::ReadAllBytes('YourCertificate.p12')) | Out-File certificate_base64.txt
```

### Convert your .mobileprovision to base64

```bash
# Git Bash / Mac / Linux:
base64 -i YourProfile.mobileprovision -o profile_base64.txt

# PowerShell on Windows:
[Convert]::ToBase64String([IO.File]::ReadAllBytes('YourProfile.mobileprovision')) | Out-File profile_base64.txt
```

### Add secrets to GitHub

1. Go to your repo on GitHub
2. Click **Settings** > **Secrets and variables** > **Actions**
3. Click **New repository secret** and add each of these:

| Secret Name | Value |
|---|---|
| `P12_BASE64` | The full contents of `certificate_base64.txt` |
| `P12_PASSWORD` | The password you set when exporting the .p12 |
| `PROVISIONING_PROFILE_BASE64` | The full contents of `profile_base64.txt` |
| `PROVISIONING_PROFILE_NAME` | The exact name of your provisioning profile (e.g. `ColorTap AdHoc`) |

---

## Step 4: Trigger a build

Every time you push to the `main` branch, GitHub will automatically:
1. Spin up a Mac server
2. Import your certificate
3. Build the app
4. Export a signed IPA
5. Upload it as a downloadable artifact

To trigger manually:
1. Go to your repo on GitHub
2. Click **Actions** tab
3. Click **Build and Export IPA** on the left
4. Click **Run workflow** > **Run workflow**

---

## Step 5: Download your IPA

1. Go to the **Actions** tab in your repo
2. Click the latest completed workflow run
3. Scroll to the bottom under **Artifacts**
4. Download **ColorTap-IPA**
5. Unzip it — your `.ipa` file is inside

---

## Step 6: Install on your iPhone

Use **Sideloadly** (free, Windows compatible) or **Apple Configurator 2** (Mac only):

**Sideloadly:**
1. Download from https://sideloadly.io
2. Connect your iPhone via USB
3. Drag the .ipa into Sideloadly
4. Sign in with your Apple ID
5. Click Start

Since you have developer certificates the app won't expire in 7 days like free accounts.

---

## Bundle ID

The bundle ID is set to `com.colortap.app`. Make sure your provisioning profile covers this bundle ID.
If you need to change it, edit `ColorTap.xcodeproj/project.pbxproj` and search for `com.colortap.app`.