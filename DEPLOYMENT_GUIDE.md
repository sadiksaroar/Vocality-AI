# Deployment Guide for Vocality AI

## Issues Resolved

### 1. ✅ Version Code Updated
**Issue:** Version code 1 has already been used
**Solution:** Updated version in `pubspec.yaml` from `1.0.0+1` to `1.0.0+2`

### 2. ⚠️ Camera Permission Privacy Policy Requirement
**Issue:** APK is using android.permission.CAMERA which requires a privacy policy

**Camera Permission Usage:**
The app uses CAMERA permission for the `image_picker` package, which allows users to:
- Take photos with the camera
- Analyze images with AI

**Required Actions for Google Play Store:**
1. **Create a Privacy Policy** (if you don't have one):
   - Host it on a publicly accessible URL (e.g., your website, GitHub Pages)
   - Include information about:
     - What data is collected (camera/images)
     - How it's used (AI analysis)
     - How it's stored and protected
     - User rights

2. **Add Privacy Policy URL to Google Play Console:**
   - Go to Google Play Console
   - Navigate to: App content > Privacy policy
   - Add your privacy policy URL
   - Save changes

**Privacy Policy Template Location:**
See `PRIVACY_POLICY_TEMPLATE.md` for a ready-to-use template you can customize.

### 3. 🔴 API 402 Payment Required Error
**Issue:** API request to `https://api.thekaren.ai/core/conversations/send_message/` returns 402 Payment Required

**Root Cause:** This is a payment/billing issue with the TheKaren AI API service

**Possible Solutions:**

#### Option A: Check API Account Status
1. Log into your TheKaren AI dashboard
2. Check your account billing status
3. Ensure you have:
   - Active subscription or credits
   - Valid payment method on file
   - Sufficient API quota remaining

#### Option B: Contact API Provider
- Email: support@thekaren.ai (or check their documentation)
- Provide: Your API key, error details, account email

#### Option C: Update API Configuration
If you have a different API key or endpoint:
1. Open `lib/core/config/app_config.dart`
2. Update the base URL if needed
3. Ensure authentication tokens are current

**Current API Configuration:**
```dart
static const String httpBase = 'https://api.thekaren.ai';
static const String sendMessagePath = '/core/conversations/send_message/';
```

## Build Instructions

After resolving the API payment issue:

### Android Release Build
```bash
flutter clean
flutter pub get
flutter build appbundle --release
# Or for APK:
flutter build apk --release
```

### Upload to Play Store
1. Go to Google Play Console
2. Create a new release in Production/Testing track
3. Upload the `.aab` file from `build/app/outputs/bundle/release/`
4. Complete the release form
5. Submit for review

## Testing the API Issue

To test if the API payment issue is resolved:
```bash
flutter run -d chrome --web-browser-flag "--disable-web-security"
```

Then try to use a feature that calls the API (e.g., send a message).

## Important Notes

- **Version Code:** Always increment for each Play Store submission
- **Privacy Policy:** Must be accessible before uploading APK with camera permissions
- **API Billing:** Resolve payment issues before deploying to production
- **Testing:** Test all API endpoints after resolving billing issues
