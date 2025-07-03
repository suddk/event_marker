# Event Marker

**Event Marker** is a cross-platform Flutter app built with Firebase that lets users create/join groups, create events (with optional image uploads), view calendars, and receive notifications.

---

## ⚙️ Stack & Key Packages

- **Framework**: Flutter + Dart SDK 3.x  
- **State Management**: Provider  
- **Backend**: Firebase (Auth, Firestore, Storage)  
- **Utilities**:
  - `image_picker` – for event image attachments  
  - `file_picker`, `path_provider`, `permission_handler` – file handling  
  - `intl` – date formatting  
  - `uuid` – generating unique IDs  
  - `table_calendar` – optional calendar view (future)

---

## 📁 Project Structure

```
lib/
├── controllers/       # Logic layer (Auth, Group, Event)
├── services/          # Firebase services (Firestore, Storage, Notifications)
├── models/            # Data models (e.g. Group, AppUser)
├── screens/           # UI layer (login, home, group, event, profile, etc.)
├── widgets/           # Reusable components (e.g. EventListWidget)
├── main.dart          # App entry point
└── firebase_options.dart
```

---

## ✅ Setup & Development

### 1. Prerequisites

- Flutter ≥ 3.x installed on macOS, Windows or Linux  
- Xcode / Android Studio for mobile platforms  
- Firebase CLI configured

### 2. Clone & Configure

```bash
git clone https://github.com/suddk/event_marker.git
cd event_marker
```

### 3. Firebase Setup

1. Create a Firebase project  
2. Register Android and iOS apps  
3. Download and place:
   - `android/app/google-services.json`
   - `ios/Runner/GoogleService-Info.plist`
4. Generate `firebase_options.dart` using the Firebase CLI:

```bash
flutterfire configure
```

### 4. Install Dependencies

Ensure your `pubspec.yaml` includes:

```yaml
firebase_core: ^2.27.0
firebase_auth: ^4.15.0
cloud_firestore: ^4.14.0
firebase_storage: ^11.6.0
provider: ^6.1.2
image_picker: ^1.1.0
intl: ^0.19.0
uuid: ^4.2.1
file_picker: ^6.1.1
path_provider: ^2.1.3
permission_handler: ^11.3.1
flutter_local_notifications: ^15.0.0
```

Then run:

```bash
flutter pub get
```

### 5. Run the App

#### Android:

```bash
flutter build apk
flutter install
```

#### iOS:

```bash
flutter build ios
```

For TestFlight:
- Open Xcode → Archive → Distribute via App Store Connect  
- Upload to TestFlight for beta testing

### 6. Launch:

```bash
flutter run
```

---

## 🛠 Common Fixes

- **`headline6` undefined** → use `titleLarge` (`Theme.of(context).textTheme.titleLarge`)  
- **`FirebaseFirestore` not found** → ensure `cloud_firestore` is imported  
- **Missing `firebase_storage`** → verify it’s in `pubspec.yaml`  
- **Authentication issues** → ensure proper use of `AuthController` and Firestore  
- **Performance** → move all API calls to `initState()` or controller logic

---

## 📱 iOS / TestFlight Notes

- Ensure you set up `Runner` bundle ID and Apple Developer Team  
- Add permissions to `Info.plist`:

```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>Used to upload images for events</string>
```

- Use Xcode Archive and TestFlight for release builds

---

## 🔭 Roadmap & Enhancements

- ✅ Core features: groups, events, auth, notifications  
- 🔜 Google Calendar sync  
- 🔜 Export to Excel/PDF  
- 🔜 Pagination for join requests  
- 🔜 Profile image upload  
- 🔜 Push notifications using `flutter_local_notifications`

---

## 📌 Troubleshooting

- **Missing packages?** Run: `flutter pub get`  
- **Permissions crash on Android?** Verify `AndroidManifest.xml` and runtime permissions  
- **Build failure on iOS?** Ensure Xcode provisioning profiles are valid  
- **Unexpected navigation behavior?** Verify routes and `Navigator` stack usage

---

## 👨‍💻 Getting Help

- Run with `flutter run --verbose` for detailed logs  
- Review Firebase console for failed API calls or rules violations  
- Submit issues on GitHub if bugs are reproducible

---

## 🎉 You’re All Set

After setup, launch the app with:

```bash
flutter run
```

Welcome to the Event Marker platform 🚀
