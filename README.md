# SumThing app

This app scans the values of QR-bills to extract monetary amounts from the scanned data and sums it.

## Features

- Scan QR codes using the device camera.
- Extract and display monetary amounts from scanned QR code data.
- Display a running total of all scanned amounts.
- Undo the last scanned value.
- Responsive UI with camera preview and overlay.

## Getting Started

### Prerequisites

- Flutter SDK installed (https://flutter.dev/docs/get-started/install)
- A device or emulator with camera support
- For web, a modern browser with camera access enabled

### Clone the repository

```bash
git clone https://github.com/Feez2403/SumThing.git
```

### Running the App

Open the repository

```bash
cd SumThing
```

2. Get dependencies:

```bash
flutter pub get
```

3. Run the app on your desired platform:

```bash
flutter run
```

For now, you can run the app on Android or Web platforms. (iOS will appear as soon as I have the appropriate hardware)

### Create a build and release the app

#### General Preparation (All Platforms)

##### Update `pubspec.yaml`

Ensure your app version and build number are up to date:

```yaml
version: 1.0.0+1
```

---

##### Clean and Get Dependencies

```bash
flutter clean
flutter pub get
```

---

#### 🌐 Web Release Build

```bash
flutter build web
```

Output will be in:

```
build/web/
```

#### 📱 Android Release Build

##### 1. Configure Signing (Required for Play Store)

Create or edit `android/key.properties`:

```properties
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=your_key_alias
storeFile=path/to/keystore.jks
```

Update `android/app/build.gradle`:

```groovy
def keystoreProperties = new Properties()
keystoreProperties.load(new FileInputStream(rootProject.file("key.properties")))

android {
    ...
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile file(keystoreProperties['storeFile'])
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}
```

---

##### 2. Build APK or AAB

**APK Build:**

```bash
flutter build apk --release
```

**AAB Build (Recommended for Play Store):**

```bash
flutter build appbundle --release
```

Output is located in:

```
build/app/outputs/
```

---

#### 🍏 iOS Release Build

iOS is not supported right now, but we will provide support in a future version.

##### 1. Open the iOS Project in Xcode

```bash
open ios/Runner.xcworkspace
```

---

##### 2. In Xcode:

- Select the **Runner** project.
- Choose **Generic iOS Device** or your connected device.
- Go to **Product > Archive**.
- Use **Organizer** to upload to the App Store or export the app.

---

##### 3. Alternatively via Command Line:

```bash
flutter build ios --release
```

> ⚠️ You need a valid **Apple Developer Account** and **Provisioning Profile** to distribute the app.

---

#### 🌐 Web Release Build

```bash
flutter build web
```

Output will be in:

```
build/web/
```

## How It Works

- The app starts with a home screen showing the app name and a button to open the QR scanner.
- When the scanner is opened, the camera view is displayed with a red overlay.
- As QR codes are scanned, the app extracts the monetary amount from the scanned text and adds it to a list of scanned values.
- The total sum of all scanned amounts is displayed on the screen.
- You can undo the last scanned value using the "Undo Last Value" button.
- The scanned values are displayed in a list on the screen.

## Code Overview

- `main.dart` contains the main app and the QR scanner widget.
- This app uses the `mobile_scanner` plugin to access the camera and scan QR codes.

## Notes

- This app is a prototype and is designed for demonstration and learning purposes.
- Make sure to grant camera permissions when prompted.

## TODO

- Support for IOS
- Add support for other currencies (for now only in CHF)
- Save scanned values to a database or file for later use
- Show relevant error messages when scanning fails

## Credits

We use the awesome [Mobile Scanner pluggin](https://pub.dev/packages/mobile_scanner)
